enum OtherGestureAction {
    case triggerVoiceRequestRegistering
    case changeToPreviousTab
    case changeToNextTab
}

extension OtherGestureAction {
    var description: String {
        switch self {
        case .triggerVoiceRequestRegistering: GestureActionText.otherGestureActionTriggerVoiceRequestRegisteringDescription.rawValue.localized()
        case .changeToPreviousTab: GestureActionText.otherGestureActionChangeToPreviousTabDescription.rawValue.localized()
        case .changeToNextTab: GestureActionText.otherGestureActionChangeToNextTabDescription.rawValue.localized()
        }
    }
}
