import AVFoundation
import SwiftUI
import UIKit
import Vision

extension MainRecognizerViewController: ObjectsRecognizing {
    func setupObjectsBoundingBoxes() {
        for _ in 0..<ObjectModel.maxBoundingBoxes {
            objectsBoundingBoxes.append(ObjectBoundingBox())
        }
        
        // Make colors for the bounding boxes. There is one color for each class,
        // 80 classes in total.
        for r: CGFloat in [0.2, 0.4, 0.6, 0.8, 1.0] {
            for g: CGFloat in [0.1, 0.3, 0.7, 0.9] {
                for b: CGFloat in [0.2, 0.4, 0.6, 0.8, 1.0] {
                    let color = UIColor(red: r, green: g, blue: b, alpha: 1)
                    objectsBoundingBoxesColors.append(color)
                }
            }
        }
    }
    
    func setupObjectsRecognizer() {
        guard let modelURL = Bundle.main.url(forResource: CameraMLModelFile.objectsRecognizer.fileName,
                                             withExtension: "mlmodelc") else {
            return
        }
        
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            
            for _ in 0..<MainRecognizerViewController.maxInflightBuffers {
                let request = VNCoreMLRequest(
                    model: visionModel,
                    completionHandler: objectsRecognitionDidComplete
                )
                
                // NOTE: If you choose another crop/scale option, then you must also
                // change how the BoundingBox objects get scaled when they are drawn.
                // Currently they assume the full input image is used.
                request.imageCropAndScaleOption = .scaleFill
                objectsRecognizerRequests.append(request)
            }
        } catch {
            return
        }
    }
    
    func prepareVisionRequestForObjectsRecognition(pixelBuffer: CVPixelBuffer) -> VNRequest {
        // The semaphore will block the capture queue and drop frames when
        // Core ML can't keep up with the camera.
        objectsRecognizerSemaphore.wait()
        
        // For better throughput, we want to schedule multiple prediction requests
        // in parallel. These need to be separate instances, and inflightBuffer is
        // the index of the current request.
        let inflightIndex = inflightBuffer
        inflightBuffer += 1
        if inflightBuffer >= MainRecognizerViewController.maxInflightBuffers {
            inflightBuffer = 0
        }
        
        return objectsRecognizerRequests[inflightIndex]
    }
    
    func objectsRecognitionDidComplete(request: VNRequest, error: Error?) {
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
//            self.showObjectsRecognitionResultsWith(predictions: boundingBoxes)
            self.saveObjectsRecognitionResultsWith(predictions: boundingBoxes)
        }
        
        self.objectsRecognizerSemaphore.signal()
    }
    
    func showObjectsRecognitionResultsWith(predictions: [Prediction]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            for i in 0..<objectsBoundingBoxes.count {
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
                    let color = objectsBoundingBoxesColors[prediction.classIndex]
                    objectsBoundingBoxes[i].show(frame: rect, label: label, color: color)
                } else {
                    objectsBoundingBoxes[i].hide()
                }
            }
            
            for box in self.objectsBoundingBoxes {
                box.addToLayer(self.previewLayer)
            }
        }
    }
    
    func saveObjectsRecognitionResultsWith(predictions: [Prediction]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            objectsRecognizerViewModel?.recognizedObjectsNames.removeAll()
            
            for i in 0..<ObjectModel.maxBoundingBoxes {
                if i < predictions.count && predictions.indices.contains(i) {
                    let prediction = predictions[i]
                    if objectModel.labels.indices.contains(prediction.classIndex) {
                        let predictedObjectLabel: String = objectModel.labels[prediction.classIndex]
                        objectsRecognizerViewModel?.recognizedObjectsNames.insert(predictedObjectLabel)
                    }
                }
            }
        }
    }
}
