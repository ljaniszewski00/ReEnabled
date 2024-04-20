extension VoiceRequest: CaseIterable {
    static var allCases: [VoiceRequest] = [
        .camera(.mainRecognizer(.readObjects)),
        .camera(.documentScanner(.readScannedDocument)),
        .camera(.colorDetector(.readDetectedColor)),
        .camera(.lightDetector(.startLightDetection)),
        .camera(.lightDetector(.stopLightDetection)),
        .chat(.sendMessage),
        .chat(.describePhoto),
        .chat(.readConversation),
        .chat(.saveCurrentConversation),
        .chat(.deleteCurrentConversation),
        .chat(.deleteAllConversations),
        .settings(.changeDefaultCameraModeToMainRecognizer),
        .settings(.changeDefaultCameraModeToDocumentScanner),
        .settings(.changeDefaultCameraModeToColorDetector),
        .settings(.changeDefaultCameraModeToLightDetector),
        .settings(.changeDefaultDistanceMeasureUnitToCentimeters),
        .settings(.changeDefaultDistanceMeasureUnitToMeters),
        .settings(.changeFlashlightTriggerModeToAutomatic),
        .settings(.changeFlashlightTriggerModeToManualWithHighTolerance),
        .settings(.changeFlashlightTriggerModeToManualWithMediumTolerance),
        .settings(.changeFlashlightTriggerModeToManualWithLowTolerance),
        .settings(.changeSpeechSpeedToFastest),
        .settings(.changeSpeechSpeedToFaster),
        .settings(.changeSpeechSpeedToNormal),
        .settings(.changeSpeechSpeedToSlower),
        .settings(.changeSpeechSpeedToSlowest),
        .settings(.changeSpeechVoiceTypeToFemale),
        .settings(.changeSpeechVoiceTypeToMale),
        .settings(.changeSpeechLanguageToEnglish),
        .settings(.changeSpeechLanguageToPolish),
        .settings(.changeVoiceRecordingLanguageToEnglish),
        .settings(.changeVoiceRecordingLanguageToPolish),
        .settings(.deleteAllConversations),
        .settings(.restoreDefaultSettings),
        .onboarding(.skip),
        .onboarding(.readPage),
        .onboarding(.previousPage),
        .onboarding(.nextPage),
        .other(.changeTabToCamera),
        .other(.recognizeObjects),
        .other(.scanDocument),
        .other(.detectColor),
        .other(.detectLight),
        .other(.changeTabToChat),
        .other(.sendNewMessage),
        .other(.changeTabToSettings),
        .other(.remindOtherVoiceCommands),
        .other(.remindGestures)
    ]
}
