import Vision
import AVFoundation
import UIKit

extension CameraViewController {
    func setupDetector() {
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3Int8LUT", withExtension: "mlmodelc") else {
            return
        }
    
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch let error {
            print(error)
        }
    }
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async(execute: {
            if let results = request.results {
                self.extractDetections(results)
            }
        })
    }
    
    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
            
            // Transformations
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
    
    func setupLayers() {
        detectionLayer = CALayer()
        detectionLayer.frame = CGRect(x: 0, 
                                      y: 0,
                                      width: screenRect.size.width,
                                      height: screenRect.size.height)
        self.view.layer.addSublayer(detectionLayer)
    }
    
    func updateLayers() {
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
                                  width: bounds.size.height - 10,
                                  height: bounds.size.width - 10)
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
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:]) // Create handler to perform request on the buffer

        do {
            try imageRequestHandler.perform(self.requests) // Schedules vision requests to be performed
        } catch {
            print(error)
        }
    }
}
