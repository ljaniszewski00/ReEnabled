enum OtherGestureAction {
    case triggerVoiceRequestRegistering
    case changeToPreviousTab
    case changeToNextTab
}

extension OtherGestureAction {
    var description: String {
        switch self {
        case .triggerVoiceRequestRegistering:
            "Trigger voice request registering"
        case .changeToPreviousTab:
            "Change to previous tab"
        case .changeToNextTab:
            "Change to next tab"
        }
    }
}
