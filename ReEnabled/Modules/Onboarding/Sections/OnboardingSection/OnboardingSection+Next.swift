extension OnboardingSection {
    func nextSection() -> OnboardingSection? {
        switch self {
        case .welcome:
                .gestures(.gesturesSectionWelcome)
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                .gestures(.tapGestureTutorial)
            case .tapGestureTutorial:
                .gestures(.doubleTapGestureTutorial)
            case .doubleTapGestureTutorial:
                .gestures(.trippleTapGestureTutorial)
            case .trippleTapGestureTutorial:
                .gestures(.longPressGestureTutorial)
            case .longPressGestureTutorial:
                .gestures(.swipeLeftGestureTutorial)
            case .swipeLeftGestureTutorial:
                .gestures(.swipeRightGestureTutorial)
            case .swipeRightGestureTutorial:
                .gestures(.swipeUpGestureTutorial)
            case .swipeUpGestureTutorial:
                .gestures(.swipeDownGestureTutorial)
            case .swipeDownGestureTutorial:
                .gestures(.longPressAndSwipeLeftGestureTutorial)
            case .longPressAndSwipeLeftGestureTutorial:
                .gestures(.longPressAndSwipeRightGestureTutorial)
            case .longPressAndSwipeRightGestureTutorial:
                .gestures(.longPressAndSwipeUpGestureTutorial)
            case .longPressAndSwipeUpGestureTutorial:
                .gestures(.longPressAndSwipeDownGestureTutorial)
            case .longPressAndSwipeDownGestureTutorial:
                .gestures(.gesturesSectionEnding)
            case .gesturesSectionEnding:
                .functions(.mainRecognizerTutorial)
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                .functions(.documentScannerTutorial)
            case .documentScannerTutorial:
                .functions(.colorDetectorTutorial)
            case .colorDetectorTutorial:
                .functions(.lightDetectorTutorial)
            case .lightDetectorTutorial:
                .functions(.chatMessageTutorial)
            case .chatMessageTutorial:
                .functions(.chatImageTutorial)
            case .chatImageTutorial:
                .functions(.chatDatabaseTutorial)
            case .chatDatabaseTutorial:
                .functions(.settingsFirstTutorial)
            case .settingsFirstTutorial:
                .functions(.settingsSecondTutorial)
            case .settingsSecondTutorial:
                .functions(.settingsThirdTutorial)
            case .settingsThirdTutorial:
                .voiceCommands(.voiceCommandsExplanation)
            }
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                .voiceCommands(.voiceCommandsRemindGestures)
            case .voiceCommandsRemindGestures:
                .voiceCommands(.voiceCommandsRemindVoiceCommands)
            case .voiceCommandsRemindVoiceCommands:
                .feedback(.feedbackFirstTutorial)
            }
        case .feedback(let onboardingFeedbackSection):
            switch onboardingFeedbackSection {
            case .feedbackFirstTutorial:
                .feedback(.feedbackSecondTutorial)
            case .feedbackSecondTutorial:
                .ending
            }
        case .ending:
            nil
        }
    }
}
