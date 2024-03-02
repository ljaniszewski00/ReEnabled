import AVFoundation

final class CaptureDepthSessionManager: CaptureDepthSessionManaging {
    private let captureDepthSessionQueue = DispatchQueue(label: "captureDepthSessionQueue")
    private let depthDataQueue = DispatchQueue(label: "depthDataQueue",
                                               qos: .userInitiated)
    
    private var depthDataOutputDelegate: AVCaptureDepthDataOutputDelegate?
    private var depthDataOutput: AVCaptureDepthDataOutput?
    
    private var videoDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInTrueDepthCamera, 
                                                                        for: .video,
                                                                        position: .front)
    
    var captureSession: AVCaptureSession!
    
    func setUp(with depthDataOutput: AVCaptureDepthDataOutput,
               and depthDataOutputDelegate: AVCaptureDepthDataOutputDelegate,
               completion: @escaping () -> ()) {
        stopCaptureSession()
        
        self.depthDataOutput = depthDataOutput
        self.depthDataOutputDelegate = depthDataOutputDelegate
        
        authorizeCaptureSession {
            completion()
        }
    }
    
    func authorizeCaptureSession(completion: @escaping () -> ())  {
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
        captureDepthSessionQueue.async { [unowned self] in
            let captureSession: AVCaptureSession = AVCaptureSession()
            
            guard let videoDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front) else {
                return
            }

            guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
                return
            }

            captureSession.beginConfiguration()
            
            captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            } else {
                return
            }
            
            guard let depthDataOutput = depthDataOutput,
                  let depthDataOutputDelegate = depthDataOutputDelegate else {
                return
            }
            
            if captureSession.canAddOutput(depthDataOutput) {
                captureSession.addOutput(depthDataOutput)
                depthDataOutput.isFilteringEnabled = false
            } else {
                return
            }
            
            let availableFormats = videoDevice.activeFormat.supportedDepthDataFormats
            let availableHdepFormats = availableFormats.filter { f in
                CMFormatDescriptionGetMediaSubType(f.formatDescription) == kCVPixelFormatType_DepthFloat16
            }
            let selectedFormat = availableHdepFormats.max(by: {
                lower, higher in CMVideoFormatDescriptionGetDimensions(lower.formatDescription).width < CMVideoFormatDescriptionGetDimensions(higher.formatDescription).width
            })
            
            depthDataOutput.setDelegate(depthDataOutputDelegate, callbackQueue: depthDataQueue)
                    
            do {
                try videoDevice.lockForConfiguration()
            } catch {
                return
            }
            
            videoDevice.activeDepthDataFormat = selectedFormat
            videoDevice.unlockForConfiguration()
            
            captureSession.commitConfiguration()
            
            self.captureSession = captureSession
            self.startCaptureSession()
            completion()
        }
    }
    
    func startCaptureSession() {
        self.captureSession?.startRunning()
    }
    
    func stopCaptureSession() {
        self.captureSession?.stopRunning()
    }
}

protocol CaptureDepthSessionManaging {
    var captureSession: AVCaptureSession! { get }
    
    func setUp(with depthDataOutput: AVCaptureDepthDataOutput,
               and depthDataOutputDelegate: AVCaptureDepthDataOutputDelegate,
               completion: @escaping () -> ())
    func startCaptureSession()
    func stopCaptureSession()
}
