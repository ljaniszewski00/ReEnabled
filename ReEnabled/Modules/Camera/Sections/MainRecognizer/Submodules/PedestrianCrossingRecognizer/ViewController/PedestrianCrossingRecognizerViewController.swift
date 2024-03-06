import AVFoundation
import SwiftUI
import UIKit
import Vision
import CoreML

class PedestrianCrossingRecognizerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Inject private var captureSessionManager: CaptureSessionManaging
    private var pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel?
    private let pedestrianCrossingModel: PedestrianCrossingModel = PedestrianCrossingModel()
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    private var screenRect: CGRect! = nil
    private var detectionOverlay: CALayer! = nil
    
    private var requests = [VNRequest]()
    
    init(pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.pedestrianCrossingRecognizerViewModel = pedestrianCrossingRecognizerViewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.pedestrianCrossingRecognizerViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionManager.setUp(with: self,
                                    for: .mainRecognizer,
                                    cameraPosition: .back,
                                    desiredFrameRate: 16.34) {
            self.setupSessionPreviewLayer()
            self.setupLayers()
            self.updateLayerGeometry()
            self.setupDetector()
            
            DispatchQueue.main.async {
                self.pedestrianCrossingRecognizerViewModel?.canDisplayCamera = true
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

extension PedestrianCrossingRecognizerViewController {
    private func setupDetector() {
        let pedestrianCrossingRecognizerModelURL = Bundle.main.url(
            forResource: MLModelFile.pedestrianCrossingRecognizer.fileName,
            withExtension: "mlmodelc"
        )
    
        do {
            if let pedestrianCrossingRecognizerModelURL = pedestrianCrossingRecognizerModelURL {
                let visionPedestrianCrossingModel = try VNCoreMLModel(for: MLModel(contentsOf: pedestrianCrossingRecognizerModelURL))
                let request = VNCoreMLRequest(model: visionPedestrianCrossingModel, completionHandler: pedestrianCrossingDetectionDidComplete)
                self.requests = [request]
            }
        } catch {
            return
        }
    }
    
    private func pedestrianCrossingDetectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            
            guard let output = results as? [VNCoreMLFeatureValueObservation] else {
                return
            }
            
            self.pedestrianCrossingModel.performCalculationsOn(output: output)
            self.pedestrianCrossingRecognizerViewModel?.pedestrianCrossingPrediction = self.pedestrianCrossingModel.pedestrianCrossingPrediction
            self.manageDetectionLayerVisibility()
            
            DispatchQueue.main.async {
                self.drawVisionRequestResults()
            }
        }
    }
    
    private func manageDetectionLayerVisibility() {
        let detectionOverlayCanBeHidden: Bool = pedestrianCrossingModel.pedestrianCrossingPrediction == nil ||
        (pedestrianCrossingModel.pedestrianCrossingPrediction?.lightColor == PedestrianCrossingLightType.none &&
         pedestrianCrossingModel.pedestrianCrossingPrediction?.personMovementInstruction == .goodPosition &&
         pedestrianCrossingModel.pedestrianCrossingPrediction?.deviceMovementInstruction == .goodOrientation)
        
        if detectionOverlayCanBeHidden {
            self.detectionOverlay.isHidden = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if detectionOverlayCanBeHidden {
                    self.detectionOverlay.isHidden = true
                } else {
                    self.detectionOverlay.isHidden = false
                }
            }
        }
    }
    
    private func drawVisionRequestResults() {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil
        
        let shapeLayer = self.createLine(points: self.pedestrianCrossingModel.points,
                                         color: UIColor.blue)
        detectionOverlay.addSublayer(shapeLayer)
        let shapeLayer2 = self.createLine(points: self.pedestrianCrossingModel.points2,
                                          color: UIColor.red)
        detectionOverlay.addSublayer(shapeLayer2)
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    func setupLayers() {
        detectionOverlay = CALayer()
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0,
                                        y: 0.0,
                                        width: captureSessionManager.bufferSize.width,
                                        height: captureSessionManager.bufferSize.height)
        detectionOverlay.position = CGPoint(x: self.view.layer.bounds.midX,
                                            y: self.view.layer.bounds.midY)
        detectionOverlay.isHidden = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.view.layer.addSublayer(self.detectionOverlay)
        }
    }
    
    func updateLayerGeometry() {
        let bounds = self.view.layer.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / captureSessionManager.bufferSize.height
        let yScale: CGFloat = bounds.size.height / captureSessionManager.bufferSize.width
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)

        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 1.0)).scaledBy(x: scale, y: -scale))
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        CATransaction.commit()
    }
    
    private func createLine(points: [Double], color: UIColor) -> CALayer {
        let shapeLayer = CALayer()
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        shapeLayer.name = "Direction Vector"
        linePath.move(to: CGPoint(x:points[2]*960+160, 
                                  y:720.0-points[3]*720))
        linePath.addLine(to: CGPoint(x:points[0]*960+160,
                                     y:720.0-points[1]*720))
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.lineWidth = 5.0
        line.strokeColor = color.cgColor
        shapeLayer.addSublayer(line)
        return shapeLayer
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(for: sampleBuffer, force: nil)
        }

        guard let cvPixelBuffer = sampleBuffer.convertToPixelBuffer() else {
            return
        }
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        let handler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer,
                                            orientation: exifOrientation)

        do {
            try handler.perform(self.requests)
        } catch {
            return
        }
    }
}
