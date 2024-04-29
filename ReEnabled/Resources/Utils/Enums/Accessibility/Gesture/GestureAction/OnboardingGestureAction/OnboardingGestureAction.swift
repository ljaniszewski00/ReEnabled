enum OnboardingGestureAction {
    case readOnboardingSection
    case changeToPreviousOnboardingSection
    case changeToNextOnboardingSection
}

extension OnboardingGestureAction {
    var description: String {
        switch self {
        case .readOnboardingSection: GestureActionText.onboardingGestureActionReadOnboardingSectionDescription.rawValue.localized()
        case .changeToPreviousOnboardingSection: GestureActionText.onboardingGestureActionChangeToPreviousOnboardingSectionDescription.rawValue.localized()
        case .changeToNextOnboardingSection: GestureActionText.onboardingGestureActionChangeToNextOnboardingSectionDescription.rawValue.localized()
        }
    }
}
