import AVFoundation
import SwiftUI
import UIKit
import Vision

extension MainRecognizerViewController: PedestrianCrossingRecognizing {
    func setupPedestrianCrossingRecognitionLayer() {
        pedestrianCrossingRecognitionLayer = CALayer()
        pedestrianCrossingRecognitionLayer.name = "DetectionOverlay"
        pedestrianCrossingRecognitionLayer.bounds = CGRect(x: 0.0,
                                                         y: 0.0,
                                                         width: captureSessionManager.bufferSize.width,
                                                         height: captureSessionManager.bufferSize.height)
        pedestrianCrossingRecognitionLayer.position = CGPoint(
            x: self.view.layer.bounds.midX,
            y: self.view.layer.bounds.midY
        )
        pedestrianCrossingRecognitionLayer.isHidden = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.view.layer.addSublayer(self.pedestrianCrossingRecognitionLayer)
        }
    }
    
    func updatePedestrianCrossingRecognitionLayerGeometry() {
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

        pedestrianCrossingRecognitionLayer.setAffineTransform(
            CGAffineTransform(
                rotationAngle: CGFloat(.pi / 1.0)
            ).scaledBy(
                x: scale,
                y: -scale
            )
        )
        
        pedestrianCrossingRecognitionLayer.position = CGPoint(x: bounds.midX,
                                                            y: bounds.midY)
        
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
    
    func setupPedestrianCrossingRecognizer() {
        let pedestrianCrossingRecognizerModelURL = Bundle.main.url(
            forResource: CameraMLModelFile.pedestrianCrossingRecognizer.fileName,
            withExtension: "mlmodelc"
        )
    
        do {
            if let pedestrianCrossingRecognizerModelURL = pedestrianCrossingRecognizerModelURL {
                let visionPedestrianCrossingModel = try VNCoreMLModel(for: MLModel(contentsOf: pedestrianCrossingRecognizerModelURL))
                let request = VNCoreMLRequest(model: visionPedestrianCrossingModel, completionHandler: pedestrianCrossingRecognitionDidComplete)
                self.pedestrianCrossingRecognizerRequests = [request]
            }
        } catch {
            return
        }
    }
    
    func pedestrianCrossingRecognitionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results,
                  let output = results as? [VNCoreMLFeatureValueObservation] else {
                return
            }
            
            self.pedestrianCrossingModel.performCalculationsOn(output: output)
            self.pedestrianCrossingRecognizerViewModel?.pedestrianCrossingPrediction = self.pedestrianCrossingModel.pedestrianCrossingPrediction
            self.managePedestrianCrossingRecognitionLayerVisibility()
            
            DispatchQueue.main.async {
                self.showPedestrianCrossingRecognitionResults()
            }
        }
    }
    
    func managePedestrianCrossingRecognitionLayerVisibility() {
        let detectionOverlayCanBeHidden: Bool = pedestrianCrossingModel.pedestrianCrossingPrediction == nil ||
        (pedestrianCrossingModel.pedestrianCrossingPrediction?.lightColor == PedestrianCrossingLightType.none &&
         pedestrianCrossingModel.pedestrianCrossingPrediction?.personMovementInstruction == .goodPosition &&
         pedestrianCrossingModel.pedestrianCrossingPrediction?.deviceMovementInstruction == .goodOrientation)
        
        if detectionOverlayCanBeHidden {
            self.pedestrianCrossingRecognitionLayer.isHidden = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if detectionOverlayCanBeHidden {
                    self.pedestrianCrossingRecognitionLayer.isHidden = true
                } else {
                    self.pedestrianCrossingRecognitionLayer.isHidden = false
                }
            }
        }
    }
    
    func showPedestrianCrossingRecognitionResults() {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        pedestrianCrossingRecognitionLayer.sublayers = nil
        
        let shapeLayer = self.createLine(points: self.pedestrianCrossingModel.points,
                                         color: UIColor.blue)
        pedestrianCrossingRecognitionLayer.addSublayer(shapeLayer)
        let shapeLayer2 = self.createLine(points: self.pedestrianCrossingModel.points2,
                                          color: UIColor.red)
        pedestrianCrossingRecognitionLayer.addSublayer(shapeLayer2)
        self.updatePedestrianCrossingRecognitionLayerGeometry()
        CATransaction.commit()
    }
}
