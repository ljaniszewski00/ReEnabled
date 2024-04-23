enum OnboardingSection: Equatable, Hashable {
    case welcome
    case gestures(OnboardingGesturesSection)
    case functions(OnboardingFunctionsSection)
    case voiceCommands(OnboardingVoiceCommandsSection)
    case feedback(OnboardingFeedbackSection)
    case ending
}

extension OnboardingSection: CaseIterable {
    static let allCases: [OnboardingSection] = [
        .welcome,
        .gestures(.gesturesSectionWelcome),
        .functions(.mainRecognizerTutorial),
        .voiceCommands(.voiceCommandsExplanation),
        .feedback(.feedbackFirstTutorial),
        .ending
    ]
}
