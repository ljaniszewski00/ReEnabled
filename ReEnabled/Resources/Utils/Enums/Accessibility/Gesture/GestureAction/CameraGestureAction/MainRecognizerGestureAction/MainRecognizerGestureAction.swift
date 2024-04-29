enum MainRecognizerGestureAction {
    case readRecognizedObjects
    
    case speakCameraModeName
    case changeToNextCameraMode
    case changeToPreviousCameraMode
}

extension MainRecognizerGestureAction {
    var description: String {
        switch self {
        case .readRecognizedObjects: GestureActionText.mainRecognizerGestureActionReadRecognizedObjectsDescription.rawValue.localized()
        case .speakCameraModeName: GestureActionText.mainRecognizerGestureActionSpeakCameraModeNameDescription.rawValue.localized()
        case .changeToNextCameraMode: GestureActionText.mainRecognizerGestureActionChangeToNextCameraModeDescription.rawValue.localized()
        case .changeToPreviousCameraMode: GestureActionText.mainRecognizerGestureActionChangeToPreviousCameraModeDescription.rawValue.localized()
        }
    }
}
