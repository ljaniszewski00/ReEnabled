enum LightDetectorSpeechFeedback {
    case cameraModeHasBeenSetTo
    case startedLightDetection
    case stoppedLightDetection
}

extension LightDetectorSpeechFeedback {
    var rawValue: String {
        switch self {
        case .cameraModeHasBeenSetTo:
            return SpeechFeedbackText.lightDetectorSpeechFeedbackCameraModeHasBeenSetTo.rawValue.localized()
        case .startedLightDetection:
            return SpeechFeedbackText.lightDetectorSpeechFeedbackStartedLightDetection.rawValue.localized()
        case .stoppedLightDetection:
            return SpeechFeedbackText.lightDetectorSpeechFeedbackStoppedLightDetection.rawValue.localized()
        }
    }
}
