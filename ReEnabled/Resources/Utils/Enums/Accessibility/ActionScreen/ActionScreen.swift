struct ActionScreen {
    let screenType: ActionScreenType
    
    var gesturesActions: [GestureType: GestureAction] {
        switch screenType {
        case .mainRecognizer:
            [
                .singleTap: .camera(.mainRecognizer(.readRecognizedObjects)),
                .trippleTap: .camera(.mainRecognizer(.speakCameraModeName)),
                .longPress: .other(.triggerVoiceRequestRegistering),
                .swipeRight: .camera(.mainRecognizer(.changeToNextCameraMode)),
                .swipeLeft: .camera(.mainRecognizer(.changeToPreviousCameraMode)),
                .longPressAndSwipeRight: .other(.changeToNextTab),
                .longPressAndSwipeLeft: .other(.changeToPreviousTab)
            ]
        case .documentScanner:
            [
                .singleTap: .camera(.documentScanner(.readDetectedTexts)),
                .doubleTap:
                        .camera(.documentScanner(.readDetectedBarCodesValues)),
                .trippleTap: .camera(.mainRecognizer(.speakCameraModeName)),
                .longPress: .other(.triggerVoiceRequestRegistering),
                .swipeRight: .camera(.mainRecognizer(.changeToNextCameraMode)),
                .swipeLeft: .camera(.mainRecognizer(.changeToPreviousCameraMode)),
                .longPressAndSwipeRight: .other(.changeToNextTab),
                .longPressAndSwipeLeft: .other(.changeToPreviousTab)
            ]
        case .colorDetector:
            [
                .singleTap: .camera(.colorDetector(.readDetectedColor)),
                .trippleTap: .camera(.mainRecognizer(.speakCameraModeName)),
                .longPress: .other(.triggerVoiceRequestRegistering),
                .swipeRight: .camera(.mainRecognizer(.changeToNextCameraMode)),
                .swipeLeft: .camera(.mainRecognizer(.changeToPreviousCameraMode)),
                .longPressAndSwipeRight: .other(.changeToNextTab),
                .longPressAndSwipeLeft: .other(.changeToPreviousTab)
            ]
        case .lightDetector:
            [
                .trippleTap: .camera(.mainRecognizer(.speakCameraModeName)),
                .longPress: .other(.triggerVoiceRequestRegistering),
                .swipeRight: .camera(.mainRecognizer(.changeToNextCameraMode)),
                .swipeLeft: .camera(.mainRecognizer(.changeToPreviousCameraMode)),
                .longPressAndSwipeRight: .other(.changeToNextTab),
                .longPressAndSwipeLeft: .other(.changeToPreviousTab)
            ]
        case .chat:
            [
                .singleTap: .chat(.triggerConversationReading),
                .doubleTap: .chat(.triggerVoiceMessageRegisteringForChat),
                .longPress: .other(.triggerVoiceRequestRegistering),
                .swipeRight: .chat(.changeConversationToNext),
                .swipeLeft: .chat(.changeConversationToPrevious),
                .longPressAndSwipeRight: .other(.changeToNextTab),
                .longPressAndSwipeLeft: .other(.changeToPreviousTab),
                .longPressAndSwipeUp: .chat(.selectPhoto),
                .longPressAndSwipeDown: .chat(.deleteCurrentConversation)
            ]
        case .settings:
            [
                .singleTap: .settings(.readSettingName),
                .doubleTap: .settings(.changeSpecificSetting),
                .trippleTap: .settings(.readSettingDescription),
                .longPress: .other(.triggerVoiceRequestRegistering),
                .longPressAndSwipeRight: .other(.changeToNextTab),
                .longPressAndSwipeLeft: .other(.changeToPreviousTab)
            ]
        case .onboarding:
            [
                .singleTap: .onboarding(.readOnboardingSection),
                .longPress: .other(.triggerVoiceRequestRegistering),
                .swipeRight: .onboarding(.changeToNextOnboardingSection),
                .swipeLeft: .onboarding(.changeToPreviousOnboardingSection)
            ]
        }
    }
}
