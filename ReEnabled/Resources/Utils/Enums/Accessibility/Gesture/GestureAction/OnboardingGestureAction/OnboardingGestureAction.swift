enum OnboardingGestureAction {
    case readOnboardingSection
    case changeToPreviousOnboardingSection
    case changeToNextOnboardingSection
}

extension OnboardingGestureAction {
    var description: String {
        switch self {
        case .readOnboardingSection:
            "Read onboarding section"
        case .changeToPreviousOnboardingSection:
            "Change to previous onboarding section"
        case .changeToNextOnboardingSection:
            "Change to next onboarding section"
        }
    }
}
