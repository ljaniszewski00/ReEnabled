enum DocumentScannerGestureAction {
    case readDetectedTexts
    case readDetectedBarCodesValues
    
    case speakCameraModeName
    case changeToNextCameraMode
    case changeToPreviousCameraMode
}

extension DocumentScannerGestureAction {
    var description: String {
        switch self {
        case .readDetectedTexts:
            "Read detected texts"
        case .readDetectedBarCodesValues:
            "Read detected bar codes values"
        case .speakCameraModeName:
            "Speak camera mode name"
        case .changeToNextCameraMode:
            "Change to next camera mode"
        case .changeToPreviousCameraMode:
            "Change to previous camera mode"
        }
    }
}
