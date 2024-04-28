enum ColorDetectorSpeechFeedback {
    case welcomeHint
    case cameraModeHasBeenSetTo
}

extension ColorDetectorSpeechFeedback {
    var rawValue: String {
        switch self {
        case .welcomeHint:
            return SpeechFeedbackText.colorDetectorSpeechFeedbackWelcomeHint.rawValue.localized()
        case .cameraModeHasBeenSetTo:
            return SpeechFeedbackText.colorDetectorSpeechFeedbackCameraModeHasBeenSetTo.rawValue.localized()
        }
    }
}
