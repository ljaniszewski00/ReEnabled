import AVFoundation
import SwiftUI
import UIKit
import Vision

class ObjectsRecognizerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let objectModel: ObjectModel = ObjectModel()
    @Inject private var captureSessionManager: CaptureSessionManaging
    private var objectsRecognizerViewModel: ObjectsRecognizerViewModel?
    
    // How many predictions we can do concurrently.
    static let maxInflightBuffers = 3
    
    private var boundingBoxes = [ObjectBoundingBox]()
    private var colors: [UIColor] = []
    
    private let ciContext = CIContext()
    
    var inflightBuffer = 0
    let semaphore = DispatchSemaphore(value: maxInflightBuffers)
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    private var screenRect: CGRect! = nil
    
    private var requests = [VNRequest]()
    
    init(objectsRecognizerViewModel: ObjectsRecognizerViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.objectsRecognizerViewModel = objectsRecognizerViewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.objectsRecognizerViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDetector()
        captureSessionManager.setUp(with: self,
                                    for: .objectRecognizer,
                                    cameraPosition: .back) {
            self.setupSessionPreviewLayer()
            self.setupBoundingBoxes()
            DispatchQueue.main.async {
                self.objectsRecognizerViewModel?.canDisplayCamera = true
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

extension ObjectsRecognizerViewController {
    func setupBoundingBoxes() {
        for _ in 0..<ObjectModel.maxBoundingBoxes {
            boundingBoxes.append(ObjectBoundingBox())
        }
        
        // Make colors for the bounding boxes. There is one color for each class,
        // 80 classes in total.
        for r: CGFloat in [0.2, 0.4, 0.6, 0.8, 1.0] {
            for g: CGFloat in [0.1, 0.3, 0.7, 0.9] {
                for b: CGFloat in [0.2, 0.4, 0.6, 0.8, 1.0] {
                    let color = UIColor(red: r, green: g, blue: b, alpha: 1)
                    colors.append(color)
                }
            }
        }
    }
    
    func setupDetector() {
        guard let modelURL = Bundle.main.url(forResource: MLModelFile.objectsRecognizer.fileName,
                                             withExtension: "mlmodelc") else {
            return
        }
        
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            
            for _ in 0..<ObjectsRecognizerViewController.maxInflightBuffers {
                let request = VNCoreMLRequest(model: visionModel,
                                              completionHandler: detectionDidComplete)
                
                // NOTE: If you choose another crop/scale option, then you must also
                // change how the BoundingBox objects get scaled when they are drawn.
                // Currently they assume the full input image is used.
                request.imageCropAndScaleOption = .scaleFill
                requests.append(request)
            }
        } catch {
            return
        }
    }
    
    func predict(pixelBuffer: CVPixelBuffer, inflightIndex: Int) {
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        let request = requests[inflightIndex]
        
        // Because perform() will block until after the request completes, we
        // run it on a concurrent background queue, so that the next frame can
        // be scheduled in parallel with this one.
        DispatchQueue.global().async {
            try? handler.perform([request])
        }
    }
    
    private func detectionDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNCoreMLFeatureValueObservation] {
            var boundingBoxes: [ObjectModel.ObjectPrediction] = []
            for feature in observations {
                if feature.featureName == "Identity" {
                    boundingBoxes += self.objectModel.computeBoundingBoxes(
                        features: feature.featureValue.multiArrayValue!,
                        scale: 22,
                        scaleIndex: 3
                    )
                } else if feature.featureName == "Identity_1" {
                    boundingBoxes += self.objectModel.computeBoundingBoxes(
                        features: feature.featureValue.multiArrayValue!,
                        scale: 44,
                        scaleIndex: 2
                    )
                } else if feature.featureName == "Identity_2" {
                    boundingBoxes += self.objectModel.computeBoundingBoxes(
                        features: feature.featureValue.multiArrayValue!,
                        scale: 88,
                        scaleIndex: 1
                    )
                }
            }
            
            // We already filtered out any bounding boxes that have very low scores,
            // but there still may be boxes that overlap too much with others. We'll
            // use "non-maximum suppression" to prune those duplicate bounding boxes.
            // The bigger threshold the bigger number of allowed bounding boxes.
            boundingBoxes = nonMaxSuppression(boxes: boundingBoxes,
                                              limit: ObjectModel.maxBoundingBoxes,
                                              threshold: 0.4)
            self.show(predictions: boundingBoxes)
        }
        
        self.semaphore.signal()
    }
    
    private func show(predictions: [Prediction]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            for i in 0..<boundingBoxes.count {
                if i < predictions.count {
                    let prediction = predictions[i]
                    
                    // The predicted bounding box is in the coordinate space of the input
                    // image, which is a square image of 416x416 pixels. We want to show it
                    // on the video preview, which is as wide as the screen and has a 16:9
                    // aspect ratio. The video preview also may be letterboxed at the top
                    // and bottom.
                    let width = view.bounds.width
                    let height = width * 16 / 9
                    let scaleX = width / CGFloat(ObjectModel.inputWidth)
                    let scaleY = height / CGFloat(ObjectModel.inputHeight)
                    let top = (view.bounds.height - height) / 2
                    
                    // Translate and scale the rectangle to our own coordinate system.
                    var rect = prediction.rect
                    rect.origin.x *= scaleX
                    rect.origin.y *= scaleY
                    rect.origin.y += top
                    rect.size.width *= scaleX
                    rect.size.height *= scaleY
                    
                    // Show the bounding box.
                    let classLabel = objectModel.labels[prediction.classIndex]
                    let label = String(format: "%@ %.1f", classLabel, prediction.score * 100)
                    let color = colors[prediction.classIndex]
                    boundingBoxes[i].show(frame: rect, label: label, color: color)
                } else {
                    boundingBoxes[i].hide()
                }
            }
            
            for box in self.boundingBoxes {
                box.addToLayer(self.previewLayer)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(for: sampleBuffer, force: nil)
        }
        
        guard let cvPixelBuffer = sampleBuffer.convertToPixelBuffer() else {
            return
        }
        
        // The semaphore will block the capture queue and drop frames when
        // Core ML can't keep up with the camera.
        semaphore.wait()
        
        // For better throughput, we want to schedule multiple prediction requests
        // in parallel. These need to be separate instances, and inflightBuffer is
        // the index of the current request.
        let inflightIndex = inflightBuffer
        inflightBuffer += 1
        if inflightBuffer >= ObjectsRecognizerViewController.maxInflightBuffers {
            inflightBuffer = 0
        }
        
        self.predict(pixelBuffer: cvPixelBuffer,
                     inflightIndex: inflightIndex)
    }
}
