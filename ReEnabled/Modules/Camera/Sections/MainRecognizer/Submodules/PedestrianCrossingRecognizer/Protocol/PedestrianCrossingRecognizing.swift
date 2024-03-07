import Vision

protocol PedestrianCrossingRecognizing {
    func setupPedestrianCrossingRecognitionLayer()
    func updatePedestrianCrossingRecognitionLayerGeometry()
    func setupPedestrianCrossingRecognizer()
    func pedestrianCrossingRecognitionDidComplete(request: VNRequest, error: Error?)
    func manageRecognitionLayerVisibility()
    func showPedestrianCrossingRecognitionResults()
}
