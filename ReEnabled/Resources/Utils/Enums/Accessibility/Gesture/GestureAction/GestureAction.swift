enum GestureAction {
    case camera(CameraGestureAction)
    case chat(ChatGestureAction)
    case settings(SettingsGestureAction)
    case onboarding(OnboardingGestureAction)
    case other(OtherGestureAction)
}

extension GestureAction {
    var description: String {
        switch self {
        case .camera(let cameraGestureAction):
            switch cameraGestureAction {
            case .mainRecognizer(let mainRecognizerGestureAction):
                mainRecognizerGestureAction.description
            case .documentScanner(let documentScannerGestureAction):
                documentScannerGestureAction.description
            case .colorDetector(let colorDetectorGestureAction):
                colorDetectorGestureAction.description
            case .lightDetector(let lightDetectorGestureAction):
                lightDetectorGestureAction.description
            }
        case .chat(let chatGestureAction):
            chatGestureAction.description
        case .settings(let settingsGestureAction):
            settingsGestureAction.description
        case .onboarding(let onboardingGestureAction):
            onboardingGestureAction.description
        case .other(let otherGestureAction):
            otherGestureAction.description
        }
    }
}
