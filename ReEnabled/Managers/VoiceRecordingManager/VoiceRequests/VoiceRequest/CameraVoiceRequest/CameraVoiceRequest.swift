enum CameraVoiceRequest {
    case mainRecognizer(MainRecognizerVoiceRequest)
    case documentScanner(DocumentScannerVoiceRequest)
    case colorDetector(ColorDetectorVoiceRequest)
    case lightDetector(LightDetectorVoiceRequest)
}

extension CameraVoiceRequest {
    static let allCases: [VoiceRequest] = MainRecognizerVoiceRequest.allCases +
    DocumentScannerVoiceRequest.allCases +
    ColorDetectorVoiceRequest.allCases +
    LightDetectorVoiceRequest.allCases
}
