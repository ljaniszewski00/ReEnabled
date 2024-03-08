import ARKit
import AVFoundation

final class CaptureSessionManager: CaptureSessionManaging {
    @Inject private var flashlightManager: FlashlightManaging
    
    private let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    private let captureSessionDataOutputQueue = DispatchQueue(
        label: "captureSessionVideoDataOutput",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem
    )
    private let captureSessionDepthDataOutputQueue = DispatchQueue(
        label: "captureSessionVideoDataOutput",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    private var sampleBufferOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    private var sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    private var depthDataOutput: AVCaptureDepthDataOutput = AVCaptureDepthDataOutput()
    private var depthDataOutputDelegate: AVCaptureDepthDataOutputDelegate?
    
    var cameraMode: CameraMode?
    private var withDepthData: Bool = false
    private var desiredFrameRate: Double?
    
    private var videoDevice: AVCaptureDevice? = AVCaptureDevice.default(
        .builtInLiDARDepthCamera,
        for: .video,
        position: .back
    )
    
    private let frontPositionedVideoDevices: [AVCaptureDevice] = AVCaptureDevice.DiscoverySession(
        deviceTypes: [
            .builtInTrueDepthCamera
        ],
        mediaType: .video,
        position: .front
    ).devices
    
    private let backPositionedVideoDevices: [AVCaptureDevice] = AVCaptureDevice.DiscoverySession(
        deviceTypes: [
            .builtInWideAngleCamera,
            .builtInDualWideCamera,
            .builtInUltraWideCamera,
            .builtInTelephotoCamera
        ],
        mediaType: .video,
        position: .back
    ).devices
    
    var bufferSize: CGSize = .zero
    
    var captureSession: AVCaptureSession!
    
    private var supportsLiDAR: Bool {
        return ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
    }
    
    func setUpWithDepthData(with sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate,
                            and depthDataOutputDelegate: AVCaptureDepthDataOutputDelegate,
                            for cameraMode: CameraMode,
                            cameraPosition: AVCaptureDevice.Position,
                            desiredFrameRate: Double,
                            completion: @escaping () -> ()) {
        stopCaptureSession()
        
        self.sampleBufferDelegate = sampleBufferDelegate
        self.depthDataOutputDelegate = depthDataOutputDelegate
        self.cameraMode = cameraMode
        self.withDepthData = supportsLiDAR ? true : false
        self.desiredFrameRate = desiredFrameRate
        
        if !(self.withDepthData && supportsLiDAR) {
            chooseVideoDevice(cameraPosition: cameraPosition)
        }
        
        authorizeCaptureSession {
            completion()
        }
    }
    
    func setUp(with bufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate,
               for cameraMode: CameraMode,
               cameraPosition: AVCaptureDevice.Position,
               desiredFrameRate: Double,
               completion: @escaping () -> ()) {
        stopCaptureSession()
        
        self.sampleBufferDelegate = bufferDelegate
        self.cameraMode = cameraMode
        self.withDepthData = false
        self.desiredFrameRate = desiredFrameRate
        
        chooseVideoDevice(cameraPosition: cameraPosition)
        
        authorizeCaptureSession {
            completion()
        }
    }
    
    func manageFlashlight(for sampleBuffer: CMSampleBuffer?, 
                          force torchMode: AVCaptureDevice.TorchMode?) {
        flashlightManager.manageFlashlight(for: sampleBuffer,
                                           and: self.videoDevice,
                                           force: torchMode)
    }
    
    private func chooseVideoDevice(cameraPosition: AVCaptureDevice.Position) {
        switch cameraPosition {
        case .front:
            guard !frontPositionedVideoDevices.isEmpty,
                  let videoDeviceToBeSet = frontPositionedVideoDevices.first(where: { device in device.position == cameraPosition }) else {
                self.videoDevice = AVCaptureDevice.default(for: .video)
                return
            }
            
            self.videoDevice = videoDeviceToBeSet
        default:
            guard !backPositionedVideoDevices.isEmpty,
                  let videoDeviceToBeSet = backPositionedVideoDevices.first(where: { device in device.position == cameraPosition }) else {
                self.videoDevice = AVCaptureDevice.default(for: .video)
                return
            }
            
            self.videoDevice = videoDeviceToBeSet
        }
    }
    
    private func authorizeCaptureSession(completion: @escaping () -> ())  {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession {
                completion()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.setupCaptureSession {
                        completion()
                    }
                }
            }
        default:
            return
        }
    }
    
    private func setupCaptureSession(completion: @escaping () -> ()) {
        captureSessionQueue.async { [unowned self] in
            var captureSession: AVCaptureSession = AVCaptureSession()
            captureSession.beginConfiguration()
            
            guard let videoDevice = videoDevice else {
                return
            }
            
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                guard captureSession.canAddInput(captureDeviceInput) else {
                    return
                }
                captureSession.addInput(captureDeviceInput)
            } catch {
                return
            }
            
            let sessionPreset: SessionPreset = .hd1280x720
            
            guard let videoSetupedCaptureSession: AVCaptureSession = setupCaptureSessionForVideo(
                captureSession: captureSession,
                sessionPreset: sessionPreset
            ) else {
                return
            }
            
            if withDepthData,
               let depthAndVideoSetupedCaptureSession = setupCaptureSessionForDepth(
                captureSession: videoSetupedCaptureSession
               ) {
                captureSession = depthAndVideoSetupedCaptureSession
            } else {
                captureSession = videoSetupedCaptureSession
            }
            
            captureSession.sessionPreset = sessionPreset.preset
            captureSession.commitConfiguration()
            
            self.captureSession = captureSession
            self.startCaptureSession()
            completion()
        }
    }
    
    private func setupCaptureSessionForVideo(captureSession: AVCaptureSession,
                                             sessionPreset: SessionPreset) -> AVCaptureSession? {
        let captureSessionVideoOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
        captureSessionVideoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(
                value: kCMPixelFormat_32BGRA
            )
        ]
        captureSessionVideoOutput.alwaysDiscardsLateVideoFrames = true
        captureSessionVideoOutput.setSampleBufferDelegate(
            self.sampleBufferDelegate,
            queue: captureSessionDataOutputQueue
        )
        
        guard let videoDevice = videoDevice,
              videoDevice.formats.indices.contains(0)  else {
            return nil
        }
        
        var formatToSet: AVCaptureDevice.Format = videoDevice.formats[0]
        
        guard let desiredFrameRate = desiredFrameRate else {
            return nil
        }
        
        for format in videoDevice.formats.reversed() {
            let ranges = format.videoSupportedFrameRateRanges
            let frameRates = ranges[0]

            if desiredFrameRate <= frameRates.maxFrameRate,
               format.formatDescription.dimensions.width == sessionPreset.formatWidth,
               format.formatDescription.dimensions.height == sessionPreset.formatHeight {
                formatToSet = format
                break
            }
        }
        
        do {
            try videoDevice.lockForConfiguration()
            
            if videoDevice.hasTorch {
                self.manageFlashlight(for: nil, force: .auto)
            }
            
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice.activeFormat.formatDescription))
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            
            videoDevice.activeFormat = formatToSet

            let timescale = CMTimeScale(desiredFrameRate)
            if videoDevice.activeFormat.videoSupportedFrameRateRanges[0].maxFrameRate >= desiredFrameRate {
                videoDevice.activeVideoMinFrameDuration = CMTime(value: 1, timescale: timescale)
                videoDevice.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: timescale)
            }
            
            videoDevice.unlockForConfiguration()
        } catch {
            return nil
        }
        
        guard captureSession.canAddOutput(captureSessionVideoOutput) else {
            return nil
        }
        
        let captureConnection = captureSessionVideoOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        
        captureSession.addOutput(captureSessionVideoOutput)
        
        if let cameraMode = self.cameraMode,
           CameraMode.modesWithPortraitVideoConnection.contains(cameraMode) {
            captureSessionVideoOutput.connection(with: .video)?.videoOrientation = .portrait
        }
        
        return captureSession
    }
    
    private func setupCaptureSessionForDepth(captureSession: AVCaptureSession) -> AVCaptureSession? {
        guard let depthDataOutputDelegate = depthDataOutputDelegate else {
            return nil
        }
        
        if captureSession.canAddOutput(depthDataOutput) {
            captureSession.addOutput(depthDataOutput)
            depthDataOutput.isFilteringEnabled = false
        } else {
            return nil
        }
        
        if let connection = depthDataOutput.connection(with: .depthData) {
            connection.isEnabled = true
            depthDataOutput.setDelegate(
                depthDataOutputDelegate,
                callbackQueue: captureSessionDepthDataOutputQueue
            )
        } else {
            return nil
        }
        
        guard let videoDevice = videoDevice else {
            return nil
        }
        
        let availableFormats = videoDevice.activeFormat.supportedDepthDataFormats
        let availableHdepFormats = availableFormats.filter { f in
            CMFormatDescriptionGetMediaSubType(f.formatDescription) == kCVPixelFormatType_DepthFloat16
        }
        let selectedFormat = availableHdepFormats.max(by: {
            lower, higher in CMVideoFormatDescriptionGetDimensions(lower.formatDescription).width < CMVideoFormatDescriptionGetDimensions(higher.formatDescription).width
        })
        
        do {
            try videoDevice.lockForConfiguration()
            videoDevice.activeDepthDataFormat = selectedFormat
            videoDevice.unlockForConfiguration()
        } catch {
            return nil
        }
        
        return captureSession
    }
    
    func startCaptureSession() {
        self.captureSession?.startRunning()
    }
    
    func stopCaptureSession() {
        self.captureSession?.stopRunning()
    }
}

protocol CaptureSessionManaging {
    var bufferSize: CGSize { get }
    var captureSession: AVCaptureSession! { get }
    
    func manageFlashlight(for sampleBuffer: CMSampleBuffer?,
                          force torchMode: AVCaptureDevice.TorchMode?)
    func setUpWithDepthData(with sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate,
                            and depthDataOutputDelegate: AVCaptureDepthDataOutputDelegate,
                            for cameraMode: CameraMode,
                            cameraPosition: AVCaptureDevice.Position,
                            desiredFrameRate: Double,
                            completion: @escaping () -> ())
    func setUp(with bufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate,
               for cameraMode: CameraMode,
               cameraPosition: AVCaptureDevice.Position,
               desiredFrameRate: Double,
               completion: @escaping () -> ())
    func startCaptureSession()
    func stopCaptureSession()
}
