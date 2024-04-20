extension ActionScreenType {
    var availableVoiceRequests: [VoiceRequest] {
        switch self {
        case .mainRecognizer:
            return MainRecognizerVoiceRequest.allCases
        case .documentScanner:
            return DocumentScannerVoiceRequest.allCases
        case .colorDetector:
            return ColorDetectorVoiceRequest.allCases
        case .lightDetector:
            return LightDetectorVoiceRequest.allCases
        case .chat:
            return ChatVoiceRequest.allCases
        case .settings:
            return SettingsVoiceRequest.allCases
        case .onboarding:
            return OnboardingVoiceRequest.allCases
        }
    }
}
