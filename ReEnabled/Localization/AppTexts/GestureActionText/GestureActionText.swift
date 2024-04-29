enum GestureActionText: String {
    case mainRecognizerGestureActionReadRecognizedObjectsDescription
    case mainRecognizerGestureActionSpeakCameraModeNameDescription
    case mainRecognizerGestureActionChangeToNextCameraModeDescription
    case mainRecognizerGestureActionChangeToPreviousCameraModeDescription
    case documentScannerGestureActionReadDetectedTextsDescription
    case documentScannerGestureActionReadDetectedBarCodesValuesDescription
    case documentScannerGestureActionSpeakCameraModeNameDescription
    case documentScannerGestureActionChangeToNextCameraModeDescription
    case documentScannerGestureActionChangeToPreviousCameraModeDescription
    case colorDetectorGestureActionReadDetectedColorDescription
    case colorDetectorGestureActionSpeakCameraModeNameDescription
    case colorDetectorGestureActionChangeToNextCameraModeDescription
    case colorDetectorGestureActionChangeToPreviousCameraModeDescription
    case lightDetectorGestureActionSpeakCameraModeNameDescription
    case lightDetectorGestureActionChangeToNextCameraModeDescription
    case lightDetectorGestureActionChangeToPreviousCameraModeDescription
    
    case chatGestureActionTriggerConversationReadingDescription
    case chatGestureActionTriggerVoiceMessageRegisteringForChatDescription
    case chatGestureActionChangeConversationToNextDescription
    case chatGestureActionChangeConversationToPreviousDescription
    case chatGestureActionDeleteCurrentConversationDescription
    case chatGestureActionSelectPhotoDescription
    
    case settingsGestureActionReadSettingNameDescription
    case settingsGestureActionChangeSpecificSettingDescription
    case settingsGestureActionReadSettingDescriptionDescription
    
    case onboardingGestureActionReadOnboardingSectionDescription
    case onboardingGestureActionChangeToPreviousOnboardingSectionDescription
    case onboardingGestureActionChangeToNextOnboardingSectionDescription
    
    case otherGestureActionTriggerVoiceRequestRegisteringDescription
    case otherGestureActionChangeToPreviousTabDescription
    case otherGestureActionChangeToNextTabDescription
}
