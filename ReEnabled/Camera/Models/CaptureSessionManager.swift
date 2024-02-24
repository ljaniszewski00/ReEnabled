import AVFoundation
import Foundation
import SwiftUI

class CaptureSessionManager: ObservableObject {
    private let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    private let videoDataOutputQueue = DispatchQueue(label: "videoDataOutput",
                                                     qos: .userInitiated,
                                                     attributes: [],
                                                     autoreleaseFrequency: .workItem)
    
    private var bufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    private var cameraMode: CameraMode?
    
    private var videoDevice: AVCaptureDevice? = AVCaptureDevice.default(for: .video)
    
    var captureSession: AVCaptureSession!
    
    private init() {}
    
    static var shared: CaptureSessionManager = {
        return CaptureSessionManager()
    }()
    
    func manageFlashlight(for sampleBuffer: CMSampleBuffer, force torchMode: AVCaptureDevice.TorchMode? = nil) {
        if let torchMode = torchMode {
            setTorchMode(torchMode)
            return
        }
        
        guard let luminosity = CaptureSessionManager.getLuminosityValueFromCamera(with: sampleBuffer) else {
            return
        }
        
        if luminosity < 1 {
            setTorchMode(.on)
        } else {
            setTorchMode(.off)
        }
    }
    
    private func setTorchMode(_ torchMode: AVCaptureDevice.TorchMode) {
        guard videoDevice != nil else {
            return
        }
        
        do {
            try videoDevice!.lockForConfiguration()
            
            if videoDevice!.hasTorch {
                videoDevice!.torchMode = torchMode
            }
            
            videoDevice!.unlockForConfiguration()
        } catch {
            return
        }
    }
    
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
                    setTorchMode(.auto)
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

extension CaptureSessionManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

extension CaptureSessionManager {
    static func getLuminosityValueFromCamera(with sampleBuffer: CMSampleBuffer) -> Double? {
        let rawMetadata = CMCopyDictionaryOfAttachments(allocator: nil,
                                                        target: sampleBuffer,
                                                        attachmentMode: CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))
        let metadata = CFDictionaryCreateMutableCopy(nil, 0, rawMetadata) as NSMutableDictionary
        
        guard let exifData = metadata.value(forKey: "{Exif}") as? NSMutableDictionary,
              let fNumber: Double = exifData["FNumber"] as? Double,
              let exposureTime: Double = exifData["ExposureTime"] as? Double,
              let ISOSpeedRatingsArray = exifData["ISOSpeedRatings"] as? NSArray,
              let ISOSpeedRatings: Double = ISOSpeedRatingsArray[0] as? Double else {
            return nil
        }
        
        let calibrationConstant: Double = 50
        
        let luminosity: Double = (calibrationConstant * fNumber * fNumber) / (exposureTime * ISOSpeedRatings)
        
        return luminosity
    }
}
