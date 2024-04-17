import AVFoundation
import SwiftUI
import UIKit
import Vision

extension MainRecognizerViewController: RoadLightsRecognizing {
    func setupRoadLightsBoundingBoxes() {
        roadLightsBoundingBoxes = [RoadLightsBoundingBox]()
        
        for _ in 0..<RoadLightsModel.maxBoundingBoxes {
            roadLightsBoundingBoxes.append(RoadLightsBoundingBox())
        }
        
        // Make colors for the bounding boxes. There is one color for each class, 20 classes in total.
        roadLightsBoundingBoxesColors.append(.red)
        roadLightsBoundingBoxesColors.append(.green)
        
        for box in roadLightsBoundingBoxes {
            box.addToLayer(self.previewLayer)
        }
    }
    
    func setupRoadLightsRecognizer() {
        let roadLightsRecognizerModelURL = Bundle.main.url(forResource: CameraMLModelFile.roadLightsRecognizer.fileName,
                                                           withExtension: "mlmodelc")
    
        do {
            if let roadLightsRecognizerModelURL = roadLightsRecognizerModelURL {
                let visionRoadLightsModel = try VNCoreMLModel(for: MLModel(contentsOf: roadLightsRecognizerModelURL))
                let request = VNCoreMLRequest(model: visionRoadLightsModel, completionHandler: roadLightsRecognitionDidComplete)
                self.roadLightsRecognizerRequests = [request]
            }
        } catch {
            return
        }
    }
    
    func roadLightsRecognitionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let results = request.results else {
                return
            }
            
            guard let observations = results as? [VNCoreMLFeatureValueObservation],
                  let features = observations.first?.featureValue.multiArrayValue else {
                return
            }
            
            let boundingBoxes = self.roadLightsModel.computeBoundingBoxes(features: features)
            
            self.roadLightsTypeManager.add(predictions: boundingBoxes)
            
            let lightType = roadLightsTypeManager.determine()
            roadLightsRecognizerViewModel?.roadLightTypeRecognized = lightType
            self.showRoadLightsRecognitionResultsWith(predictions: boundingBoxes)
        }
    }
    
    func showRoadLightsRecognitionResultsWith(predictions: [Prediction]) {
        for i in 0..<roadLightsBoundingBoxes.count {
            if i < predictions.count {
                let prediction = predictions[i]
                
                // The predicted bounding box is in the coordinate space of the input
                // image, which is a square image of 416x416 pixels. We want to show it
                // on the video preview, which is as wide as the screen and has a 4:3
                // aspect ratio. The video preview also may be letterboxed at the top
                // and bottom.
                let width = view.bounds.width
                let height = width * (16 / 9)
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
                let color = roadLightsBoundingBoxesColors[prediction.classIndex]
                roadLightsBoundingBoxes[i].show(frame: rect, label: label, color: color)
            } else {
                roadLightsBoundingBoxes[i].hide()
            }
        }
    }
}
