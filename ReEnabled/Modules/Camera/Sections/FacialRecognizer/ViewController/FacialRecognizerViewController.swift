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
        captureSessionManager.setUp(with: self,
                                    for: .mainRecognizer,
                                    cameraPosition: .front,
                                    desiredFrameRate: 30) {
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
            guard let results = request.results else {
                return
            }
            
            print("Gender Recognition Results:")
            for result in results {
                print(result)
            }
            print()
            
            guard let observations = request.results as? [VNClassificationObservation] else {
                return
            }
            
            print("Gender Recognition Array:")
            let recognizedGenderString = observations
                .compactMap({ observation in
                    observation.identifier
                })
            print(recognizedGenderString)
            print()
            
            print("Recognized Gender:")
            print(recognizedGenderString.first)
            print()
            self.facialRecognizerViewModel?.recognizedGender = recognizedGenderString.first ?? ""
            print("Recognize Gender turned on? \(self.facialRecognizerViewModel?.recognizeGender)")
            print()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.facialRecognizerViewModel?.recognizeGender = false
            }
        }
    }
    
    private func ageDetectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            
            print("Age Recognition Results:")
            for result in results {
                print(result)
            }
            print()
            
            guard let observations = request.results as? [VNClassificationObservation] else {
                return
            }
            
            print("Age Recognition Array:")
            let recognizedAgeString = observations
                .compactMap({ observation in
                    observation.identifier
                })
            print(recognizedAgeString)
            print()
            
            print("Recognized Age:")
            print(recognizedAgeString.first)
            print()
            self.facialRecognizerViewModel?.recognizedAge = recognizedAgeString.first ?? ""
            print("Recognize Age turned on? \(self.facialRecognizerViewModel?.recognizeAge)")
            print()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.facialRecognizerViewModel?.recognizeAge = false
            }
        }
    }
    
    private func emotionDetectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            
            print("Emotion Recognition Results:")
            for result in results {
                print(result)
            }
            print()
            
            guard let observations = request.results as? [VNClassificationObservation] else {
                return
            }
            
            print("Emotion Recognition Array:")
            let recognizedEmotionString = observations
                .compactMap({ observation in
                    observation.identifier
                })
            print(recognizedEmotionString)
            print()
            
            print("Recognized Emotion:")
            print(recognizedEmotionString.first)
            print()
            self.facialRecognizerViewModel?.recognizedEmotion = recognizedEmotionString.first ?? ""
            print("Recognize Emotions turned on? \(self.facialRecognizerViewModel?.recognizeEmotions)")
            print()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.facialRecognizerViewModel?.recognizeEmotions = false
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(for: sampleBuffer, force: nil)
        }
        
        let imageRequestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)

        do {
            if let recognitionEnabled = facialRecognizerViewModel?.recognitionEnabled,
               recognitionEnabled {
                try imageRequestHandler.perform(self.genderRequests)
                try imageRequestHandler.perform(self.ageRequests)
                try imageRequestHandler.perform(self.emotionsRequests)
            }
        } catch {
            return
        }
    }
}
