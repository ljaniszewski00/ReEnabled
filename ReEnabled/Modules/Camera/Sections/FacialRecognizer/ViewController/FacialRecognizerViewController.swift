import AVFoundation
import SwiftUI
import UIKit
import Vision
import CoreML

class FacialRecognizerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Inject private var captureSessionManager: CaptureSessionManaging
    private var facialRecognizerViewModel: FacialRecognizerViewModel?
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil
    
    private var genderRequests = [VNRequest]()
    private var ageRequests = [VNRequest]()
    private var emotionsRequests = [VNRequest]()
    
    init(facialRecognizerViewModel: FacialRecognizerViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.facialRecognizerViewModel = facialRecognizerViewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.facialRecognizerViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionManager.setUp(with: self, for: .objectRecognizer) {
            self.setupSessionPreviewLayer()
            self.setupDetectors()
            DispatchQueue.main.async {
                self.facialRecognizerViewModel?.canDisplayCamera = true
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRect = UIScreen.main.bounds
        self.previewLayer.frame = CGRect(x: 0,
                                         y: 0,
                                         width: screenRect.size.width,
                                         height: screenRect.size.height)

        switch UIDevice.current.orientation {
        case UIDeviceOrientation.portraitUpsideDown:
            self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case UIDeviceOrientation.landscapeLeft:
            self.previewLayer.connection?.videoOrientation = .landscapeRight
        case UIDeviceOrientation.landscapeRight:
            self.previewLayer.connection?.videoOrientation = .landscapeLeft
        case UIDeviceOrientation.portrait:
            self.previewLayer.connection?.videoOrientation = .portrait
        default:
            break
        }
    }
    
    private func setupSessionPreviewLayer() {
        screenRect = UIScreen.main.bounds
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

extension FacialRecognizerViewController {
    private func setupDetectors() {
        setupGenderDetector()
        setupAgeDetector()
        setupEmotionDetector()
    }
    
    private func setupGenderDetector() {
        let genderRecognizerModelURL = Bundle.main.url(forResource: MLModelFile.genderRecognizer.fileName,
                                                       withExtension: "mlmodelc")
    
        do {
            if let genderRecognizerModelURL = genderRecognizerModelURL {
                let visionGenderModel = try VNCoreMLModel(for: MLModel(contentsOf: genderRecognizerModelURL))
                let request = VNCoreMLRequest(model: visionGenderModel, completionHandler: genderDetectionDidComplete)
                self.emotionsRequests = [request]
            }
        } catch {
            return
        }
    }
    
    private func setupAgeDetector() {
        let ageRecognizerModelURL = Bundle.main.url(forResource: MLModelFile.ageRecognizer.fileName,
                                                    withExtension: "mlmodelc")
    
        do {
            if let ageRecognizerModelURL = ageRecognizerModelURL {
                let visionAgeModel = try VNCoreMLModel(for: MLModel(contentsOf: ageRecognizerModelURL))
                let request = VNCoreMLRequest(model: visionAgeModel, completionHandler: ageDetectionDidComplete)
                self.ageRequests = [request]
            }
        } catch {
            return
        }
    }
    
    private func setupEmotionDetector() {
        let emotionsRecognizerModelURL = Bundle.main.url(forResource: MLModelFile.emotionsRecognizer.fileName,
                                                         withExtension: "mlmodelc")
    
        do {
            if let emotionsRecognizerModelURL = emotionsRecognizerModelURL {
                let visionEmotionModel = try VNCoreMLModel(for: MLModel(contentsOf: emotionsRecognizerModelURL))
                let request = VNCoreMLRequest(model: visionEmotionModel, completionHandler: emotionDetectionDidComplete)
                self.emotionsRequests = [request]
            }
        } catch {
            return
        }
    }
    
    private func genderDetectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let observations = request.results as? [VNClassificationObservation] else {
                return
            }
            
            guard let recognizedGenderString = observations
                .compactMap({ observation in
                    observation.identifier
                })
                .first else {
                return
            }
            
            self.facialRecognizerViewModel?.recognizedGender = recognizedGenderString
        }
    }
    
    private func ageDetectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let observations = request.results as? [VNClassificationObservation] else {
                return
            }
            
            guard let recognizedAgeString = observations
                .compactMap({ observation in
                    observation.identifier
                })
                .first else {
                return
            }
            
            self.facialRecognizerViewModel?.recognizedAge = recognizedAgeString
        }
    }
    
    private func emotionDetectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let observations = request.results as? [VNClassificationObservation] else {
                return
            }
            
            guard let recognizedEmotionString = observations
                .compactMap({ observation in
                    observation.identifier
                })
                .first else {
                return
            }
            
            self.facialRecognizerViewModel?.recognizedEmotion = recognizedEmotionString
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(for: sampleBuffer, force: nil)
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])

        do {
            try imageRequestHandler.perform(self.genderRequests)
            try imageRequestHandler.perform(self.ageRequests)
            try imageRequestHandler.perform(self.emotionsRequests)
        } catch {
            return
        }
    }
}
