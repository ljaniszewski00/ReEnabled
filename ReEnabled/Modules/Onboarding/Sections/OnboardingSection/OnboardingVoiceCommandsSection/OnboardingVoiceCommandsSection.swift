enum OnboardingVoiceCommandsSection {
    case voiceCommandsExplanation
    case voiceCommandsRemindGestures
    case voiceCommandsRemindVoiceCommands
}

extension OnboardingVoiceCommandsSection: CaseIterable {
    static let allCases: [OnboardingVoiceCommandsSection] = [
        .voiceCommandsExplanation,
        .voiceCommandsRemindGestures,
        .voiceCommandsRemindVoiceCommands
    ]
}
