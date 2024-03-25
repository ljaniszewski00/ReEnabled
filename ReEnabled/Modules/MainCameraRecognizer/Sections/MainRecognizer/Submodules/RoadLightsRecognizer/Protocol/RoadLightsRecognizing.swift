import Vision

protocol RoadLightsRecognizing {
    func setupRoadLightsBoundingBoxes()
    func setupRoadLightsRecognizer()
    func roadLightsRecognitionDidComplete(request: VNRequest, error: Error?)
    func showRoadLightsRecognitionResultsWith(predictions: [Prediction])
}
