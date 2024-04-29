enum LightDetectorGestureAction {
    case speakCameraModeName
    case changeToNextCameraMode
    case changeToPreviousCameraMode
}

extension LightDetectorGestureAction {
    var description: String {
        switch self {
        case .speakCameraModeName: GestureActionText.lightDetectorGestureActionSpeakCameraModeNameDescription.rawValue.localized()
        case .changeToNextCameraMode: GestureActionText.lightDetectorGestureActionChangeToNextCameraModeDescription.rawValue.localized()
        case .changeToPreviousCameraMode: GestureActionText.lightDetectorGestureActionChangeToPreviousCameraModeDescription.rawValue.localized()
        }
    }
}
