enum LightDetectorGestureAction {
    case speakCameraModeName
    case changeToNextCameraMode
    case changeToPreviousCameraMode
}

extension LightDetectorGestureAction {
    var description: String {
        switch self {
        case .speakCameraModeName:
            "Speak camera mode name"
        case .changeToNextCameraMode:
            "Change to next camera mode"
        case .changeToPreviousCameraMode:
            "Change to previous camera mode"
        }
    }
}
