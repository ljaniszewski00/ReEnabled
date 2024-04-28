enum DocumentScannerSpeechFeedback {
    case welcomeHint
    case cameraModeHasBeenSetTo
    case noTextHasBeenRecognized
    case hereIsRecognizedText
    case noBarCodesHaveBeenRecognized
    case hereIsRecognizedBarCodeText
}

extension DocumentScannerSpeechFeedback {
    var rawValue: String {
        switch self {
        case .welcomeHint:
            return SpeechFeedbackText.documentScannerSpeechFeedbackWelcomeHint.rawValue.localized()
        case .cameraModeHasBeenSetTo:
            return SpeechFeedbackText.documentScannerSpeechFeedbackCameraModeHasBeenSetTo.rawValue.localized()
        case .noTextHasBeenRecognized:
            return SpeechFeedbackText.documentScannerSpeechFeedbackNoTextHasBeenRecognized.rawValue.localized()
        case .hereIsRecognizedText:
            return SpeechFeedbackText.documentScannerSpeechFeedbackHereIsRecognizedText.rawValue.localized()
        case .noBarCodesHaveBeenRecognized:
            return SpeechFeedbackText.documentScannerSpeechFeedbackNoBarCodesHaveBeenRecognized.rawValue.localized()
        case .hereIsRecognizedBarCodeText:
            return SpeechFeedbackText.documentScannerSpeechFeedbackHereIsRecognizedBarCodeText.rawValue.localized()
        }
    }
}
