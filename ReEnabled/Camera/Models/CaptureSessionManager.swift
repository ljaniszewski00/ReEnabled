import AVFoundation
import Foundation
import SwiftUI

class CaptureSessionManager: ObservableObject {
    private let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput",
                                                     qos: .userInitiated,
                                                     attributes: [],
                                                     autoreleaseFrequency: .workItem)
    
    private var bufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    private var cameraMode: CameraMode?
    
    var captureSession: AVCaptureSession!
    
    private init() {}
    
    static var shared: CaptureSessionManager = {
        return CaptureSessionManager()
    }()
    
    func setUp(with bufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate,
               for cameraMode: CameraMode,
               completion: @escaping () -> ()) {
        stopCaptureSession()
        
        self.bufferDelegate = bufferDelegate
        self.cameraMode = cameraMode
        
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
        captureSessionQueue.async { [unowned self] in
            let captureSession: AVCaptureSession = AVCaptureSession()
            captureSession.beginConfiguration()
            
            guard let videoDevice = AVCaptureDevice.default(for: .video) else {
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
                videoDevice.unlockForConfiguration()
            } catch {
                return
            }
            
            guard captureSession.canAddOutput(videoOutput) else {
                return
            }
            
            if cameraMode == .objectRecognizer {
                let captureConnection = videoOutput.connection(with: .video)
                captureConnection?.isEnabled = true
            }
            
            captureSession.addOutput(videoOutput)
            
            if cameraMode == .objectRecognizer {
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
        case .lightDetector:
            return nil
        case .currencyDetector:
            return nil
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

extension CaptureSessionManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
