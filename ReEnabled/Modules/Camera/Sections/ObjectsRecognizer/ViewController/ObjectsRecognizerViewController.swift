import AVFoundation
import SwiftUI
import UIKit
import Vision

class ObjectsRecognizerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Inject private var captureSessionManager: CaptureSessionManaging
    private var objectsRecognizerViewModel: ObjectsRecognizerViewModel?
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil
    
    var requests = [VNRequest]()
    var detectionLayer: CALayer! = nil
    
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
        captureSessionManager.setUp(with: self, 
                                    for: .objectRecognizer,
                                    cameraPosition: .back) {
            self.setupSessionPreviewLayer()
            self.setupLayers()
            self.setupDetector()
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
        
        updateLayers()
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
    private func setupDetector() {
        guard let modelURL = Bundle.main.url(forResource: MLModelFile.YOLOv3Int8LUT.fileName,
                                             withExtension: "mlmodelc") else {
            return
        }
    
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch {
            return
        }
    }
    
    private func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let results = request.results {
                self.extractDetections(results)
            }
        }
    }
    
    private func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
            
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox,
                                                            Int(screenRect.size.width),
                                                            Int(screenRect.size.height))
            
            let transformedBounds = CGRect(x: objectBounds.minX,
                                           y: screenRect.size.height - objectBounds.maxY,
                                           width: objectBounds.maxX - objectBounds.minX,
                                           height: objectBounds.maxY - objectBounds.minY)
            
            let boxLayer = self.createBoundingBoxIn(transformedBounds)
            let textLayer = self.createTextSubLayerIn(objectBounds,
                                                      identifier: objectObservation.labels[0].identifier)

            boxLayer.addSublayer(textLayer)
            detectionLayer.addSublayer(boxLayer)
            self.view.layer.addSublayer(detectionLayer)
        }
    }
    
    private func setupLayers() {
        detectionLayer = CALayer()
        detectionLayer.frame = CGRect(x: 0,
                                      y: 0,
                                      width: screenRect.size.width,
                                      height: screenRect.size.height)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.view.layer.addSublayer(self.detectionLayer)
        }
    }
    
    private func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0,
                                       y: 0,
                                       width: screenRect.size.width,
                                       height: screenRect.size.height)
    }
    
    private func createTextSubLayerIn(_ bounds: CGRect, identifier: String) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        let formattedIdentifierString = NSMutableAttributedString(string: String(format: "\(identifier)", identifier))
        let largeFont = UIFont(name: "Helvetica",
                               size: 24.0)!
        
        formattedIdentifierString.addAttributes([NSAttributedString.Key.font: largeFont,
                                                 NSAttributedString.Key.foregroundColor: UIColor.yellow],
                                                range: NSRange(location: 0,
                                                               length: identifier.count))
        
        textLayer.string = formattedIdentifierString
        
        textLayer.bounds = CGRect(x: 0,
                                  y: 0,
                                  width: bounds.midX - 10,
                                  height: bounds.midY - 10)
        textLayer.position = CGPoint(x: bounds.midX - 5,
                                     y: bounds.midY - 5)
        textLayer.shadowOpacity = 0.7
        textLayer.shadowOffset = CGSize(width: 2,
                                        height: 2)
        return textLayer
    }
    
    private func createBoundingBoxIn(_ bounds: CGRect) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = UIColor.yellow.cgColor
        boxLayer.cornerRadius = 4
        return boxLayer
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(for: sampleBuffer, force: nil)
        }
        
        let imageRequestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)

        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            return
        }
    }
}
