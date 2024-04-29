enum ColorDetectorGestureAction {
    case readDetectedColor
    
    case speakCameraModeName
    case changeToNextCameraMode
    case changeToPreviousCameraMode
}

extension ColorDetectorGestureAction {
    var description: String {
        switch self {
        case .readDetectedColor: GestureActionText.colorDetectorGestureActionReadDetectedColorDescription.rawValue.localized()
        case .speakCameraModeName: GestureActionText.colorDetectorGestureActionSpeakCameraModeNameDescription.rawValue.localized()
        case .changeToNextCameraMode: GestureActionText.colorDetectorGestureActionChangeToNextCameraModeDescription.rawValue.localized()
        case .changeToPreviousCameraMode: GestureActionText.colorDetectorGestureActionChangeToPreviousCameraModeDescription.rawValue.localized()
        }
    }
}
