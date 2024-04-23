enum OnboardingFunctionsSection {
    case mainRecognizerTutorial
    case documentScannerTutorial
    case colorDetectorTutorial
    case lightDetectorTutorial
    case chatMessageTutorial
    case chatImageTutorial
    case chatDatabaseTutorial
    case settingsFirstTutorial
    case settingsSecondTutorial
    case settingsThirdTutorial
}

extension OnboardingFunctionsSection: CaseIterable {
    static let allCases: [OnboardingFunctionsSection] = [
        .mainRecognizerTutorial,
        .documentScannerTutorial,
        .colorDetectorTutorial,
        .lightDetectorTutorial,
        .chatMessageTutorial,
        .chatImageTutorial,
        .chatDatabaseTutorial,
        .settingsFirstTutorial,
        .settingsSecondTutorial,
        .settingsThirdTutorial
    ]
}
