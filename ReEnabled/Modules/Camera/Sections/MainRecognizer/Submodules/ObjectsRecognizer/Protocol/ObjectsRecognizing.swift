import AVFoundation
import Vision

protocol ObjectsRecognizing {
    func setupBoundingBoxes()
    func setupObjectsRecognizer()
    func manageCaptureOutputForObjectsRecognizer(pixelBuffer: CVPixelBuffer)
    func predict(pixelBuffer: CVPixelBuffer, inflightIndex: Int)
    func objectsRecognitionDidComplete(request: VNRequest, error: Error?)
    func showObjectsRecognitionResultsWith(predictions: [Prediction])
}
