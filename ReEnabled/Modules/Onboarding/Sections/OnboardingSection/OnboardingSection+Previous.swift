extension OnboardingSection {
    func previousSection() -> OnboardingSection? {
        switch self {
        case .welcome:
            nil
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                .welcome
            case .tapGestureTutorial:
                .gestures(.gesturesSectionWelcome)
            case .doubleTapGestureTutorial:
                .gestures(.tapGestureTutorial)
            case .trippleTapGestureTutorial:
                .gestures(.doubleTapGestureTutorial)
            case .longPressGestureTutorial:
                .gestures(.trippleTapGestureTutorial)
            case .swipeLeftGestureTutorial:
                .gestures(.longPressGestureTutorial)
            case .swipeRightGestureTutorial:
                .gestures(.swipeLeftGestureTutorial)
            case .swipeUpGestureTutorial:
                .gestures(.swipeRightGestureTutorial)
            case .swipeDownGestureTutorial:
                .gestures(.swipeUpGestureTutorial)
            case .longPressAndSwipeLeftGestureTutorial:
                .gestures(.swipeDownGestureTutorial)
            case .longPressAndSwipeRightGestureTutorial:
                .gestures(.longPressAndSwipeLeftGestureTutorial)
            case .longPressAndSwipeUpGestureTutorial:
                .gestures(.longPressAndSwipeRightGestureTutorial)
            case .longPressAndSwipeDownGestureTutorial:
                .gestures(.longPressAndSwipeUpGestureTutorial)
            case .gesturesSectionEnding:
                .gestures(.longPressAndSwipeDownGestureTutorial)
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                .gestures(.longPressAndSwipeDownGestureTutorial)
            case .documentScannerTutorial:
                .functions(.mainRecognizerTutorial)
            case .colorDetectorTutorial:
                .functions(.documentScannerTutorial)
            case .lightDetectorTutorial:
                .functions(.colorDetectorTutorial)
            case .chatMessageTutorial:
                .functions(.lightDetectorTutorial)
            case .chatImageTutorial:
                .functions(.chatMessageTutorial)
            case .chatDatabaseTutorial:
                .functions(.chatImageTutorial)
            case .settingsFirstTutorial:
                .functions(.chatDatabaseTutorial)
            case .settingsSecondTutorial:
                .functions(.settingsFirstTutorial)
            case .settingsThirdTutorial:
                .functions(.settingsSecondTutorial)
            }
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                .functions(.settingsThirdTutorial)
            case .voiceCommandsRemindGestures:
                .voiceCommands(.voiceCommandsExplanation)
            case .voiceCommandsRemindVoiceCommands:
                .voiceCommands(.voiceCommandsRemindGestures)
            }
        case .feedback(let onboardingFeedbackSection):
            switch onboardingFeedbackSection {
            case .feedbackFirstTutorial:
                .voiceCommands(.voiceCommandsRemindVoiceCommands)
            case .feedbackSecondTutorial:
                .feedback(.feedbackFirstTutorial)
            }
        case .ending:
            .feedback(.feedbackSecondTutorial)
        }
    }
}
