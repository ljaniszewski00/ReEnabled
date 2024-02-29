import AVFoundation

final class CaptureSessionManager: CaptureSessionManaging {
    @Inject private var flashlightManager: FlashlightManaging
    
    private let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    private let videoDataOutputQueue = DispatchQueue(label: "videoDataOutput",
                                                     qos: .userInitiated,
                                                     attributes: [],
                                                     autoreleaseFrequency: .workItem)
    
    private var bufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    private var cameraMode: CameraMode?
    
    private var videoDevice: AVCaptureDevice? = AVCaptureDevice.default(for: .video)
    
    var captureSession: AVCaptureSession!
    
    func setUp(with bufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate,
               for cameraMode: CameraMode,
               cameraPosition: AVCaptureDevice.Position,
               completion: @escaping () -> ()) {
        stopCaptureSession()
        
        self.bufferDelegate = bufferDelegate
        self.cameraMode = cameraMode
        
        switch cameraPosition {
        case .unspecified:
            self.videoDevice = AVCaptureDevice.default(for: .video)
        case .back:
            self.videoDevice = AVCaptureDevice.default(for: .video)
        case .front:
            self.videoDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front)
        @unknown default:
            self.videoDevice = AVCaptureDevice.default(for: .video)
        }
        
        authorizeCaptureSession {
            completion()
        }
    }
    
    func manageFlashlight(for sampleBuffer: CMSampleBuffer?, force torchMode: AVCaptureDevice.TorchMode?) {
        flashlightManager.manageFlashlight(for: sampleBuffer,
                                           and: self.videoDevice,
                                           force: torchMode)
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
    
    private func setupCaptureSession(completion: @escaping () -> (), for captureDevice: AVCaptureDevice? = nil) {
        captureSessionQueue.async { [unowned self] in
            let captureSession: AVCaptureSession = AVCaptureSession()
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
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = getVideoSettings()
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self.bufferDelegate,
                                                queue: videoDataOutputQueue)
            
            do {
                try videoDevice.lockForConfiguration()
                
                if videoDevice.hasTorch {
                    self.manageFlashlight(for: nil, force: .auto)
                }
                
                videoDevice.unlockForConfiguration()
            } catch {
                return
            }
            
            guard captureSession.canAddOutput(videoOutput) else {
                return
            }
            
            if let cameraMode = self.cameraMode,
               CameraMode.modesWithPortraitVideoConnection.contains(cameraMode) {
                let captureConnection = videoOutput.connection(with: .video)
                captureConnection?.isEnabled = true
            }
            
            captureSession.addOutput(videoOutput)
            
            if let cameraMode = self.cameraMode,
               CameraMode.modesWithPortraitVideoConnection.contains(cameraMode) {
                videoOutput.connection(with: .video)?.videoOrientation = .portrait
            }
            
            captureSession.sessionPreset = .hd1280x720
            captureSession.commitConfiguration()
            
            self.captureSession = captureSession
            self.startCaptureSession()
            completion()
        }
    }
    
    private func getVideoSettings() -> [String: Any]? {
        switch cameraMode {
        case .objectRecognizer:
            return [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        case .colorDetector:
            return [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCMPixelFormat_32BGRA)]
        default:
            return nil
        }
    }
    
    func startCaptureSession() {
        self.captureSession?.startRunning()
    }
    
    func stopCaptureSession() {
        self.captureSession?.stopRunning()
    }
}

protocol CaptureSessionManaging {
    var captureSession: AVCaptureSession! { get }
    
    func manageFlashlight(for sampleBuffer: CMSampleBuffer?,
                          force torchMode: AVCaptureDevice.TorchMode?)
    func setUp(with bufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate,
               for cameraMode: CameraMode,
               cameraPosition: AVCaptureDevice.Position,
               completion: @escaping () -> ())
    func startCaptureSession()
    func stopCaptureSession()
}
