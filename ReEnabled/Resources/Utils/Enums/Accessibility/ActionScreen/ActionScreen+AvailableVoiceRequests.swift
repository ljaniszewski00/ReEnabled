extension ActionScreenType {
    var availableVoiceRequests: [VoiceRequest] {
        switch self {
        case .mainRecognizer:
            MainRecognizerVoiceRequest.allCases + OtherVoiceRequest.casesForOtherTabs
        case .documentScanner:
            DocumentScannerVoiceRequest.allCases + OtherVoiceRequest.casesForOtherTabs
        case .colorDetector:
            ColorDetectorVoiceRequest.allCases + OtherVoiceRequest.casesForOtherTabs
        case .lightDetector:
            LightDetectorVoiceRequest.allCases + OtherVoiceRequest.casesForOtherTabs
        case .chat:
            ChatVoiceRequest.allCases + OtherVoiceRequest.casesForOtherTabs
        case .settings:
            SettingsVoiceRequest.allCases + OtherVoiceRequest.casesForOtherTabs
        case .onboarding:
            OnboardingVoiceRequest.allCases
        }
    }
}
