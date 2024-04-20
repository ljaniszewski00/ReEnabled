enum CameraGestureAction {
    case mainRecognizer(MainRecognizerGestureAction)
    case documentScanner(DocumentScannerGestureAction)
    case colorDetector(ColorDetectorGestureAction)
    case lightDetector(LightDetectorGestureAction)
}
