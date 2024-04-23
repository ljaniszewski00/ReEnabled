enum OnboardingFeedbackSection {
    case feedbackFirstTutorial
    case feedbackSecondTutorial
}

extension OnboardingFeedbackSection: CaseIterable {
    static let allCases: [OnboardingFeedbackSection] = [
        .feedbackFirstTutorial,
        .feedbackSecondTutorial
    ]
}
