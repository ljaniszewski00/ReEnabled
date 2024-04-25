extension OnboardingSection {
    var shouldReadTitle: Bool {
        switch self {
        case .welcome:
            return true
        case .gestures(_):
            return true
        case .functions(_):
            return false
        case .voiceCommands(_):
            return false
        case .feedback(_):
            return false
        case .ending:
            return true
        }
    }
}
