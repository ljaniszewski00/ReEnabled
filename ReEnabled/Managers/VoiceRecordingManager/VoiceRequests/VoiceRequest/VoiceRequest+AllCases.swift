extension VoiceRequest: CaseIterable {
    static var allCases: [VoiceRequest] = CameraVoiceRequest.allCases +
    ChatVoiceRequest.allCases +
    SettingsVoiceRequest.allCases +
    OnboardingVoiceRequest.allCases +
    OtherVoiceRequest.allCases
}
