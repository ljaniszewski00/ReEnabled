extension SpeechFeedback: CaseIterable {
    static var allCases: [SpeechFeedback] = [
        .camera(.lightDetector(.startedLightDetection)),
        .camera(.lightDetector(.stoppedLightDetection)),
        .chat(.thisIsTheResponse),
        .chat(.conversationDeleted),
        .chat(.allConversationsDeleted),
        .chat(.photoUploadedSayMessage),
        .chat(.photoUploaded),
        .settings(.defaultCameraModeHasBeenSetTo),
        .settings(.defaultMeasureUnitHasBeenSetTo),
        .settings(.scannerLanguageHasBeenSetTo),
        .settings(.flashlightTriggerModeHasBeenSetTo),
        .settings(.speechSpeedHasBeenSetTo),
        .settings(.speechVoiceTypeHasBeenSetTo),
        .settings(.speechLanguageHasBeenSetTo),
        .settings(.voiceRecordingLanguageHasBeenSetTo),
        .settings(.allConversationsDeleted),
        .settings(.restoredDefaultSettings),
        .onboarding(.onboardingHasBeenSkipped)
    ]
}
