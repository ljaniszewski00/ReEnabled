enum SpeechFeedbackText: String {
    case mainRecognizerSpeechFeedbackWelcomeHint
    case mainRecognizerSpeechFeedbackCameraModeHasBeenSetTo
    case mainRecognizerSpeechFeedbackNoObjectsRecognized
    case mainRecognizerSpeechFeedbackFollowingObjectsHaveBeenRecognized
    case mainRecognizerSpeechFeedbackDistanceToDominantObjectInCamera
    case mainRecognizerSpeechFeedbackDistanceWarning
    case mainRecognizerSpeechFeedbackRedLightHasBeenDetected
    case mainRecognizerSpeechFeedbackGreenLightHasBeenDetected
    case mainRecognizerSpeechFeedbackPedestrianCrossingHasBeenDetectedHereAreTheInstructions
    case mainRecognizerSpeechFeedbackPersonGoodPosition
    case mainRecognizerSpeechFeedbackPersonMoveLeft
    case mainRecognizerSpeechFeedbackPersonMoveRight
    case mainRecognizerSpeechFeedbackDeviceGoodOrientation
    case mainRecognizerSpeechFeedbackDeviceTurnLeft
    case mainRecognizerSpeechFeedbackDeviceTurnRight
    case documentScannerSpeechFeedbackWelcomeHint
    case documentScannerSpeechFeedbackCameraModeHasBeenSetTo
    case documentScannerSpeechFeedbackNoTextHasBeenRecognized
    case documentScannerSpeechFeedbackHereIsRecognizedText
    case documentScannerSpeechFeedbackNoBarCodesHaveBeenRecognized
    case documentScannerSpeechFeedbackHereIsRecognizedBarCodeText
    case colorDetectorSpeechFeedbackCameraModeHasBeenSetTo
    case colorDetectorSpeechFeedbackWelcomeHint
    case lightDetectorSpeechFeedbackCameraModeHasBeenSetTo
    case lightDetectorSpeechFeedbackStartedLightDetection
    case lightDetectorSpeechFeedbackStoppedLightDetection
    case chatSpeechFeedbackWelcomeHint
    case chatSpeechFeedbackThisIsTheResponse
    case chatSpeechFeedbackConversationDeleted
    case chatSpeechFeedbackAllConversationsDeleted
    case chatSpeechFeedbackPhotoUploadedSayMessage
    case chatSpeechFeedbackPhotoUploaded
    case chatSpeechFeedbackWhatYouWantToKnow
    case settingsSpeechFeedbackWelcomeHint
    case settingsSpeechFeedbackDefaultCameraModeHasBeenSetTo
    case settingsSpeechFeedbackDefaultMeasureUnitHasBeenSetTo
    case settingsSpeechFeedbackFlashlightTriggerModeHasBeenSetTo
    case settingsSpeechFeedbackSpeechSpeedHasBeenSetTo
    case settingsSpeechFeedbackSpeechVoiceTypeHasBeenSetTo
    case settingsSpeechFeedbackSpeechLanguageHasBeenSetTo
    case settingsSpeechFeedbackVoiceRecordingLanguageHasBeenSetTo
    case settingsSpeechFeedbackSubscriptionPlanHasBeenChangedTo
    case settingsSpeechFeedbackAllConversationsDeleted
    case settingsSpeechFeedbackRestoredDefaultSettings
    case settingsSpeechFeedbackDoubleTapToDisplayOnboarding
    case settingsSpeechFeedbackDoubleTapToDeleteConversations
    case settingsSpeechFeedbackDoubleTapToRestoreDefaultSettings
    case onboardingSpeechFeedbackOnboardingHasBeenCompleted
    case onboardingSpeechFeedbackSwipeRightToProceed
    case otherSpeechFeedbackCurrentTab
    case otherSpeechFeedbackTabChangedTo
    case otherSpeechFeedbackYouCanUseFollowingVoiceCommands
    case otherSpeechFeedbackYouCanUseFollowingGestures
    case otherSpeechFeedbackVoiceCommandWasNotRecognized
    case otherSpeechFeedbackWhatYouWantMeToDo
    
    case speechFeedbackGesturesReminderTo
}
