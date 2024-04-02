enum CameraVoiceRequest {
    case mainRecognizer(MainRecognizerVoiceRequest)
    case documentScanner(DocumentScannerVoiceRequest)
    case colorDetector(ColorDetectorVoiceRequest)
    case lightDetector(LightDetectorVoiceRequest)
}
