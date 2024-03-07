import AVFoundation
import Vision

protocol ObjectsRecognizing {
    func setupObjectsBoundingBoxes()
    func setupObjectsRecognizer()
    func prepareVisionRequestForObjectsRecognition(pixelBuffer: CVPixelBuffer) -> VNRequest
    func objectsRecognitionDidComplete(request: VNRequest,
                                       error: Error?)
    func showObjectsRecognitionResultsWith(predictions: [Prediction])
}
