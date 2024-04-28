enum OnboardingVoiceRequest {
    case skipOnboarding
    case readSection
    case previousSection
    case nextSection
}

extension OnboardingVoiceRequest {
    var rawValue: String {
        switch self {
        case .skipOnboarding:
            return VoiceRequestText.onboardingVoiceRequestSkipOnboarding.rawValue.localized()
        case .readSection:
            return VoiceRequestText.onboardingVoiceRequestReadSection.rawValue.localized()
        case .previousSection:
            return VoiceRequestText.onboardingVoiceRequestPreviousSection.rawValue.localized()
        case .nextSection:
            return VoiceRequestText.onboardingVoiceRequestNextSection.rawValue.localized()
        }
    }
}

extension OnboardingVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .onboarding(.skipOnboarding),
        .onboarding(.readSection),
        .onboarding(.previousSection),
        .onboarding(.nextSection)
    ]
}
