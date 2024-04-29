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
        case .readDetectedTexts: GestureActionText.documentScannerGestureActionReadDetectedTextsDescription.rawValue.localized()
        case .readDetectedBarCodesValues: GestureActionText.documentScannerGestureActionReadDetectedBarCodesValuesDescription.rawValue.localized()
        case .speakCameraModeName: GestureActionText.documentScannerGestureActionSpeakCameraModeNameDescription.rawValue.localized()
        case .changeToNextCameraMode: GestureActionText.documentScannerGestureActionChangeToNextCameraModeDescription.rawValue.localized()
        case .changeToPreviousCameraMode: GestureActionText.documentScannerGestureActionChangeToPreviousCameraModeDescription.rawValue.localized()
        }
    }
}
