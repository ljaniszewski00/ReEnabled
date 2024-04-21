enum ColorDetectorGestureAction {
    case readDetectedColor
    
    case speakCameraModeName
    case changeToNextCameraMode
    case changeToPreviousCameraMode
}

extension ColorDetectorGestureAction {
    var description: String {
        switch self {
        case .readDetectedColor:
            "Read detected color"
        case .speakCameraModeName:
            "Speak camera mode name"
        case .changeToNextCameraMode:
            "Change to next camera mode"
        case .changeToPreviousCameraMode:
            "Change to previous camera mode"
        }
    }
}
