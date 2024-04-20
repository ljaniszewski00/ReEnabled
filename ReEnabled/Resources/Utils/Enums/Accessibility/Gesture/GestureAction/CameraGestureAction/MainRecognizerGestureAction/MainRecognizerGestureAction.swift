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
            <#code#>
        case .changeToNextCameraMode:
            <#code#>
        case .changeToPreviousCameraMode:
            <#code#>
        }
    }
}
