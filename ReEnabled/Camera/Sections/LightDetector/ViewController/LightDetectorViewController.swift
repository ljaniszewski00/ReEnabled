import UIKit
import AVFoundation

class LightDetectorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let lightDetectorViewModel: LightDetectorViewModel = .shared
    private let captureSessionManager: CaptureSessionManager = .shared
    
    var screenRect: CGRect = UIScreen.main.bounds
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionManager.setUp(with: self, for: .lightDetector) {
            self.setupUI()
            DispatchQueue.main.async {
                self.lightDetectorViewModel.canDisplayCamera = true
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let rawMetadata = CMCopyDictionaryOfAttachments(allocator: nil, 
                                                        target: sampleBuffer,
                                                        attachmentMode: CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))
        let metadata = CFDictionaryCreateMutableCopy(nil, 0, rawMetadata) as NSMutableDictionary
        
        guard let luminosity = getLuminosityValueFromCamera(metadata: metadata) else {
            return
        }
    
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(luminosity: luminosity)
            self.lightDetectorViewModel.luminosity = luminosity
        }
    }
    
    private func getLuminosityValueFromCamera(metadata: NSMutableDictionary) -> Double? {
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
    
    private func setupUI() {
        setSessionPreviewLayer()
    }
    
    private func setSessionPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSessionManager.captureSession)
        previewLayer.frame = CGRect(x: 0,
                                    y: 0,
                                    width: screenRect.size.width,
                                    height: screenRect.size.height)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.view.layer.addSublayer(self.previewLayer)
        }
    }
}
