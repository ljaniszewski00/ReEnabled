enum SpeechFeedback {
    case camera(CameraSpeechFeedback)
    case chat(ChatSpeechFeedback)
    case settings(SettingsSpeechFeedback)
    case onboarding(OnboardingSpeechFeedback)
    case other(OtherSpeechFeedback)
    case empty
}

extension SpeechFeedback: SpeechFeedbackRawRepresentable {
    var rawValue: String {
        switch self {
        case .camera(let cameraSpeechFeedback):
            switch cameraSpeechFeedback {
            case .mainRecognizer(let mainRecognizerSpeechFeedback):
                return mainRecognizerSpeechFeedback.rawValue
            case .documentScanner(let documentScannerSpeechFeedback):
                return documentScannerSpeechFeedback.rawValue
            case .colorDetector(let colorDetectorSpeechFeedback):
                return colorDetectorSpeechFeedback.rawValue
            case .lightDetector(let lightDetectorSpeechFeedback):
                return lightDetectorSpeechFeedback.rawValue
            }
        case .chat(let chatSpeechFeedback):
            return chatSpeechFeedback.rawValue
        case .settings(let settingsSpeechFeedback):
            return settingsSpeechFeedback.rawValue
        case .onboarding(let onboardingSpeechFeedback):
            return onboardingSpeechFeedback.rawValue
        case .other(let otherSpeechFeedback):
            return otherSpeechFeedback.rawValue
        case .empty:
            return ""
        }
    }
}

extension SpeechFeedback: Equatable {
    static func == (lhs: SpeechFeedback, rhs: SpeechFeedback) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

protocol SpeechFeedbackRawRepresentable {
    var rawValue: String { get }
}
