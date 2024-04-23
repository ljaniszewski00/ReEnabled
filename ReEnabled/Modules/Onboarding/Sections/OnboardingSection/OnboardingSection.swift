enum OnboardingSection: Equatable {
    case welcome
    case gestures(OnboardingGesturesSection)
    case functions(OnboardingFunctionsSection)
    case voiceCommands(OnboardingVoiceCommandsSection)
    case feedback(OnboardingFeedbackSection)
    case ending
}
