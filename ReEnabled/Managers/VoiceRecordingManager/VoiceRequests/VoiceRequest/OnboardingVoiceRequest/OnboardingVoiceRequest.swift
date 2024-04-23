enum OnboardingVoiceRequest: String {
    case skip = "Skip"
    case readSection = "Read section"
    case previousSection = "Previous section"
    case nextSection = "Next section"
}

extension OnboardingVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .onboarding(.skip),
        .onboarding(.readSection),
        .onboarding(.previousSection),
        .onboarding(.nextSection)
    ]
}
