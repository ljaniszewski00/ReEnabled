import AVFoundation

final class SingleTakeCameraManager {
    private let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    
    var bufferSize: CGSize = .zero
    var captureSession: AVCaptureSession!
    
    var photoOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    var flashMode = AVCaptureDevice.FlashMode.off
    
    func setUp(completion: @escaping () -> ()) {
        authorizeCaptureSession {
            completion()
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
            let captureSession: AVCaptureSession = AVCaptureSession()
            captureSession.beginConfiguration()
            
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera],
                                                           mediaType: AVMediaType.video,
                                                           position: .back)
            guard let camera = session.devices.compactMap({ $0 }).first else {
                return
            }
            
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: camera)
                guard captureSession.canAddInput(captureDeviceInput) else {
                    return
                }
                captureSession.addInput(captureDeviceInput)
            } catch {
                return
            }
            
            photoOutput.isLivePhotoCaptureEnabled = false

            guard captureSession.canAddOutput(photoOutput) else {
                return
            }
            
            captureSession.sessionPreset = .photo
            captureSession.addOutput(photoOutput)

            captureSession.commitConfiguration()
            
            self.captureSession = captureSession
            self.captureSession.startRunning()
            completion()
        }
    }
}
