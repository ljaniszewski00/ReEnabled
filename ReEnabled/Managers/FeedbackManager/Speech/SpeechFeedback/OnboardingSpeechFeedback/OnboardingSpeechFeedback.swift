enum OnboardingSpeechFeedback {
    case onboardingHasBeenCompleted
    case swipeRightToProceed
}

extension OnboardingSpeechFeedback {
    var rawValue: String {
        switch self {
        case .onboardingHasBeenCompleted:
            return SpeechFeedbackText.onboardingSpeechFeedbackOnboardingHasBeenCompleted.rawValue.localized()
        case .swipeRightToProceed:
            return SpeechFeedbackText.onboardingSpeechFeedbackSwipeRightToProceed.rawValue.localized()
        }
    }
}
