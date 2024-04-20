enum OnboardingVoiceRequest: String {
    case skip = "Skip"
    case readPage = "Read page"
    case previousPage = "Previous page"
    case nextPage = "Next page"
}

extension OnboardingVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .onboarding(.skip),
        .onboarding(.readPage),
        .onboarding(.previousPage),
        .onboarding(.nextPage)
    ]
}
