extension OnboardingSection {
    var title: String? {
        switch self {
        case .welcome:
            return OnboardingText.titleWelcomeSectionWelcomeText.rawValue.localized()
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return OnboardingText.titleGesturesSectionWelcomeText.rawValue.localized()
            case .tapGestureTutorial:
                return OnboardingText.titleTapGestureTutorial.rawValue.localized()
            case .doubleTapGestureTutorial:
                return OnboardingText.titleDoubleTapGestureTutorial.rawValue.localized()
            case .trippleTapGestureTutorial:
                return OnboardingText.titleTrippleTapGestureTutorial.rawValue.localized()
            case .longPressGestureTutorial:
                return OnboardingText.titleLongPressGestureTutorial.rawValue.localized()
            case .swipeLeftGestureTutorial:
                return OnboardingText.titleSwipeLeftGestureTutorial.rawValue.localized()
            case .swipeRightGestureTutorial:
                return OnboardingText.titleSwipeRightGestureTutorial.rawValue.localized()
            case .swipeUpGestureTutorial:
                return OnboardingText.titleSwipeUpGestureTutorial.rawValue.localized()
            case .swipeDownGestureTutorial:
                return OnboardingText.titleSwipeDownGestureTutorial.rawValue.localized()
            case .longPressAndSwipeLeftGestureTutorial:
                return OnboardingText.titleLongPressAndSwipeLeftGestureTutorial.rawValue.localized()
            case .longPressAndSwipeRightGestureTutorial:
                return OnboardingText.titleLongPressAndSwipeRightGestureTutorial.rawValue.localized()
            case .longPressAndSwipeUpGestureTutorial:
                return OnboardingText.titleLongPressAndSwipeUpGestureTutorial.rawValue.localized()
            case .longPressAndSwipeDownGestureTutorial:
                return OnboardingText.titleLongPressAndSwipeDownGestureTutorial.rawValue.localized()
            case .gesturesSectionEnding:
                return OnboardingText.titleGesturesSectionEnding.rawValue.localized()
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                return OnboardingText.titleMainRecognizerTutorial.rawValue.localized()
            case .documentScannerTutorial:
                return OnboardingText.titleMainRecognizerTutorial.rawValue.localized()
            case .colorDetectorTutorial:
                return OnboardingText.titleMainRecognizerTutorial.rawValue.localized()
            case .lightDetectorTutorial:
                return OnboardingText.titleMainRecognizerTutorial.rawValue.localized()
            case .chatMessageTutorial:
                return OnboardingText.titleChatMessageTutorial.rawValue.localized()
            case .chatImageTutorial:
                return OnboardingText.titleChatMessageTutorial.rawValue.localized()
            case .chatDatabaseTutorial:
                return OnboardingText.titleChatMessageTutorial.rawValue.localized()
            case .settingsFirstTutorial:
                return OnboardingText.titleSettingsFirstTutorial.rawValue.localized()
            case .settingsSecondTutorial:
                return OnboardingText.titleSettingsFirstTutorial.rawValue.localized()
            case .settingsThirdTutorial:
                return OnboardingText.titleSettingsFirstTutorial.rawValue.localized()
            }
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                return OnboardingText.titleVoiceCommandsExplanation.rawValue.localized()
            case .voiceCommandsRemindGestures:
                return OnboardingText.titleVoiceCommandsExplanation.rawValue.localized()
            case .voiceCommandsRemindVoiceCommands:
                return OnboardingText.titleVoiceCommandsExplanation.rawValue.localized()
            }
        case .feedback(let onboardingFeedbackSection):
            switch onboardingFeedbackSection {
            case .feedbackFirstTutorial:
                return OnboardingText.titleFeedbackFirstTutorial.rawValue.localized()
            case .feedbackSecondTutorial:
                return OnboardingText.titleFeedbackFirstTutorial.rawValue.localized()
            }
        case .ending:
            return OnboardingText.titleEnding.rawValue.localized()
        }
    }
    
    var description: String {
        switch self {
        case .welcome:
            return OnboardingText.descriptionWelcomeSectionWelcomeText.rawValue.localized()
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return OnboardingText.descriptionGesturesSectionWelcomeText.rawValue.localized()
            case .tapGestureTutorial:
                return OnboardingText.descriptionTapGestureTutorial.rawValue.localized()
            case .doubleTapGestureTutorial:
                return OnboardingText.descriptionDoubleTapGestureTutorial.rawValue.localized()
            case .trippleTapGestureTutorial:
                return OnboardingText.descriptionTrippleTapGestureTutorial.rawValue.localized()
            case .longPressGestureTutorial:
                return OnboardingText.descriptionLongPressGestureTutorial.rawValue.localized()
            case .swipeLeftGestureTutorial:
                return OnboardingText.descriptionSwipeLeftGestureTutorial.rawValue.localized()
            case .swipeRightGestureTutorial:
                return OnboardingText.descriptionSwipeRightGestureTutorial.rawValue.localized()
            case .swipeUpGestureTutorial:
                return OnboardingText.descriptionSwipeUpGestureTutorial.rawValue.localized()
            case .swipeDownGestureTutorial:
                return OnboardingText.descriptionSwipeDownGestureTutorial.rawValue.localized()
            case .longPressAndSwipeLeftGestureTutorial:
                return OnboardingText.descriptionLongPressAndSwipeLeftGestureTutorial.rawValue.localized()
            case .longPressAndSwipeRightGestureTutorial:
                return OnboardingText.descriptionLongPressAndSwipeRightGestureTutorial.rawValue.localized()
            case .longPressAndSwipeUpGestureTutorial:
                return OnboardingText.descriptionLongPressAndSwipeUpGestureTutorial.rawValue.localized()
            case .longPressAndSwipeDownGestureTutorial:
                return OnboardingText.descriptionLongPressAndSwipeDownGestureTutorial.rawValue.localized()
            case .gesturesSectionEnding:
                return OnboardingText.descriptionGesturesSectionEnding.rawValue.localized()
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                return OnboardingText.descriptionMainRecognizerTutorial.rawValue.localized()
            case .documentScannerTutorial:
                return OnboardingText.descriptionDocumentScannerTutorial.rawValue.localized()
            case .colorDetectorTutorial:
                return OnboardingText.descriptionColorDetectorTutorial.rawValue.localized()
            case .lightDetectorTutorial:
                return OnboardingText.descriptionLightDetectorTutorial.rawValue.localized()
            case .chatMessageTutorial:
                return OnboardingText.descriptionChatMessageTutorial.rawValue.localized()
            case .chatImageTutorial:
                return OnboardingText.descriptionChatImageTutorial.rawValue.localized()
            case .chatDatabaseTutorial:
                return OnboardingText.descriptionChatDatabaseTutorial.rawValue.localized()
            case .settingsFirstTutorial:
                return OnboardingText.descriptionSettingsFirstTutorial.rawValue.localized()
            case .settingsSecondTutorial:
                return OnboardingText.descriptionSettingsSecondTutorial.rawValue.localized()
            case .settingsThirdTutorial:
                return OnboardingText.descriptionSettingsThirdTutorial.rawValue.localized()
            }
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                return OnboardingText.descriptionVoiceCommandsExplanation.rawValue.localized()
            case .voiceCommandsRemindGestures:
                return OnboardingText.descriptionVoiceCommandsRemindGestures.rawValue.localized()
            case .voiceCommandsRemindVoiceCommands:
                return OnboardingText.descriptionVoiceCommandsRemindVoiceCommands.rawValue.localized()
            }
        case .feedback(let onboardingFeedbackSection):
            switch onboardingFeedbackSection {
            case .feedbackFirstTutorial:
                return OnboardingText.descriptionFeedbackFirstTutorial.rawValue.localized()
            case .feedbackSecondTutorial:
                return OnboardingText.descriptionFeedbackSecondTutorial.rawValue.localized()
            }
        case .ending:
            return OnboardingText.descriptionEnding.rawValue.localized()
        }
    }
}
