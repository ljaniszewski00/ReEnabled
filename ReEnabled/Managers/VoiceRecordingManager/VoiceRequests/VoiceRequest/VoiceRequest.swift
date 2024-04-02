enum VoiceRequest {
    case camera(CameraVoiceRequest)
    case chat(ChatVoiceRequest)
    case settings(SettingsVoiceRequest)
    case onboarding(OnboardingVoiceRequest)
    case other(OtherVoiceRequest)
}

extension VoiceRequest: VoiceRequestRawRepresentable {
    var rawValue: String {
        switch self {
        case .camera(let cameraVoiceRequest):
            switch cameraVoiceRequest {
            case .mainRecognizer(let mainRecognizerVoiceRequest):
                return mainRecognizerVoiceRequest.rawValue
            case .documentScanner(let documentScannerVoiceRequest):
                return documentScannerVoiceRequest.rawValue
            case .colorDetector(let colorDetectorVoiceRequest):
                return colorDetectorVoiceRequest.rawValue
            case .lightDetector(let lightDetectorVoiceRequest):
                return lightDetectorVoiceRequest.rawValue
            }
        case .chat(let chatVoiceRequest):
            return chatVoiceRequest.rawValue
        case .settings(let settingsVoiceRequest):
            return settingsVoiceRequest.rawValue
        case .onboarding(let onboardingVoiceRequest):
            return onboardingVoiceRequest.rawValue
        case .other(let otherVoiceRequest):
            return otherVoiceRequest.rawValue
        }
    }
}

protocol VoiceRequestRawRepresentable {
    var rawValue: String { get }
}
