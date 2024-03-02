import AVFoundation
import SwiftUI
import UIKit
import Vision
import CoreML

class RoadTrafficRecognizerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let roadLightsModel = RoadLightsModel()
    private let roadLightsPhaseManager = RoadLightsPhaseManager(confidenceThreshold: 0,
                                                        maxDetections: RoadLightsModel.maxBoundingBoxes,
                                                        minIOU: 0.3)
    
    var boundingBoxes = [BoundingBox]()
    var colors: [UIColor] = []
    
    @Inject private var captureSessionManager: CaptureSessionManaging
    private var roadTrafficRecognizerViewModel: RoadTrafficRecognizerViewModel?
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil
    
    private var roadSignsRequests = [VNRequest]()
    private var roadLightsRequests = [VNRequest]()
    
    init(roadTrafficRecognizerViewModel: RoadTrafficRecognizerViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.roadTrafficRecognizerViewModel = roadTrafficRecognizerViewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.roadTrafficRecognizerViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionManager.setUp(with: self,
                                    for: .roadTrafficRecognizer,
                                    cameraPosition: .back) {
            self.setupSessionPreviewLayer()
            self.setUpBoundingBoxes()
            self.setupDetectors()
            DispatchQueue.main.async {
                self.roadTrafficRecognizerViewModel?.canDisplayCamera = true
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
    
    func setUpBoundingBoxes() {
        boundingBoxes = [BoundingBox]()
        
        for _ in 0..<RoadLightsModel.maxBoundingBoxes {
            boundingBoxes.append(BoundingBox())
        }
        
        // Make colors for the bounding boxes. There is one color for each class, 20 classes in total.
        colors.append(.red)
        colors.append(.green)
        
        for box in boundingBoxes {
            box.addToLayer(self.previewLayer)
        }
    }
}

extension RoadTrafficRecognizerViewController {
    private func setupDetectors() {
        setupRoadSignsDetector()
        setupRoadLightsDetector()
    }
    
    private func setupRoadSignsDetector() {
        let roadSignsRecognizerModelURL = Bundle.main.url(forResource: MLModelFile.roadSignsRecognizer.fileName,
                                                       withExtension: "mlmodelc")
    
        do {
            if let roadSignsRecognizerModelURL = roadSignsRecognizerModelURL {
                let visionRoadSignsModel = try VNCoreMLModel(for: MLModel(contentsOf: roadSignsRecognizerModelURL))
                let request = VNCoreMLRequest(model: visionRoadSignsModel, completionHandler: roadSignsDetectionDidComplete)
                self.roadSignsRequests = [request]
            }
        } catch {
            return
        }
    }
    
    private func setupRoadLightsDetector() {
        let roadLightsRecognizerModelURL = Bundle.main.url(forResource: MLModelFile.roadLightsRecognizer.fileName,
                                                           withExtension: "mlmodelc")
    
        do {
            if let roadLightsRecognizerModelURL = roadLightsRecognizerModelURL {
                let visionRoadLightsModel = try VNCoreMLModel(for: MLModel(contentsOf: roadLightsRecognizerModelURL))
                let request = VNCoreMLRequest(model: visionRoadLightsModel, completionHandler: roadLightsDetectionDidComplete)
                self.roadLightsRequests = [request]
            }
        } catch {
            return
        }
    }
    
    private func roadSignsDetectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            
            print("Road Signs Recognition Results:")
            for result in results {
                print(result)
            }
            print()
            
            guard let observations = request.results as? [VNClassificationObservation] else {
                return
            }
            
            print("Road Signs Recognition Array:")
            let recognizedRoadSignString = observations
                .compactMap({ observation in
                    observation.identifier
                })
            print(recognizedRoadSignString)
            print()
            
            print("Recognized Road Sign:")
            print(recognizedRoadSignString.first)
            print()
            self.roadTrafficRecognizerViewModel?.recognizedRoadSign = recognizedRoadSignString.first ?? ""
        }
    }
    
    private func roadLightsDetectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let results = request.results else {
                return
            }
            
            guard let observations = request.results as? [VNCoreMLFeatureValueObservation],
                  let features = observations.first?.featureValue.multiArrayValue else {
                return
            }
            
            let boundingBoxes = self.roadLightsModel.computeBoundingBoxes(features: features)
            
            self.roadLightsPhaseManager.add(predictions: boundingBoxes)
            
            let lightPhase = roadLightsPhaseManager.determine()
            print(lightPhase)
            self.show(predictions: boundingBoxes)
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(for: sampleBuffer, force: nil)
        }

        guard let cvPixelBuffer = sampleBuffer.convertToPixelBuffer() else {
            return
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, orientation: .up)

        do {
            try imageRequestHandler.perform(self.roadSignsRequests)
            try imageRequestHandler.perform(self.roadLightsRequests)
        } catch {
            return
        }
    }
    
    private func show(predictions: [RoadLightsModel.Prediction]) {
        for i in 0..<boundingBoxes.count {
            if i < predictions.count {
                let prediction = predictions[i]
                
                // The predicted bounding box is in the coordinate space of the input
                // image, which is a square image of 416x416 pixels. We want to show it
                // on the video preview, which is as wide as the screen and has a 4:3
                // aspect ratio. The video preview also may be letterboxed at the top
                // and bottom.
                let width = view.bounds.width
                let height = width * (self.captureSessionManager.captureSession.sessionPreset == .vga640x480 ? (4 / 3) : (16 / 9))
                let scaleX = width / CGFloat(RoadLightsModel.inputWidth)
                let scaleY = height / CGFloat(RoadLightsModel.inputHeight)
                let top = (view.bounds.height - height) / 2
                
                // Translate and scale the rectangle to our own coordinate system.
                var rect = prediction.rect
                rect.origin.x *= scaleX
                rect.origin.y *= scaleY
                rect.origin.y += top
                rect.size.width *= scaleX
                rect.size.height *= scaleY
                
                // Show the bounding box.
                let label = String(format: "%@ %.1f", roadLightsModel.labels[prediction.classIndex], prediction.score * 100)
                let color = colors[prediction.classIndex]
                boundingBoxes[i].show(frame: rect, label: label, color: color)
            } else {
                boundingBoxes[i].hide()
            }
        }
    }
}
