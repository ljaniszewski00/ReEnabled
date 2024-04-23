enum OnboardingVoiceRequest: String {
    case skipOnboarding = "Skip onboarding"
    case readSection = "Read section"
    case previousSection = "Previous section"
    case nextSection = "Next section"
}

extension OnboardingVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .onboarding(.skipOnboarding),
        .onboarding(.readSection),
        .onboarding(.previousSection),
        .onboarding(.nextSection)
    ]
}
