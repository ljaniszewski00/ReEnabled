enum CameraSpeechFeedback {
    case mainRecognizer(MainRecognizerSpeechFeedback)
    case documentScanner(DocumentScannerSpeechFeedback)
    case colorDetector(ColorDetectorSpeechFeedback)
    case lightDetector(LightDetectorSpeechFeedback)
}
