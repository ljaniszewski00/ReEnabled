enum MainRecognizerGestureAction {
    case readRecognizedObjects
    
    case speakCameraModeName
    case changeToNextCameraMode
    case changeToPreviousCameraMode
}

extension MainRecognizerGestureAction {
    var description: String {
        switch self {
        case .readRecognizedObjects:
            "Read recognized objects"
        case .speakCameraModeName:
            "Speak camera mode name"
        case .changeToNextCameraMode:
            "Change to next camera mode"
        case .changeToPreviousCameraMode:
            "Change to previous camera mode"
        }
    }
}
