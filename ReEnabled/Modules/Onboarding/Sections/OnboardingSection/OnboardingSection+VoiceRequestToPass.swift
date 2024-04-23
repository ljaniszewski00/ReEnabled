extension OnboardingSection {
    var voiceRequestToPass: VoiceRequest? {
        switch self {
        case .voiceCommands(let voiceCommandsOnboardingSection):
            switch voiceCommandsOnboardingSection {
            case .voiceCommandsExplanation:
                return nil
            case .voiceCommandsRemindGestures:
                return .other(.remindGestures)
            case .voiceCommandsRemindVoiceCommands:
                return nil
            }
        default:
            return nil
        }
    }
}
