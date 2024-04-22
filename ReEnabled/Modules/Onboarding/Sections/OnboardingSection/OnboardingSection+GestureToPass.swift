extension OnboardingSection {
    var gestureToPass: GestureType? {
        switch self {
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return nil
            case .tapGestureTutorial:
                return .singleTap
            case .doubleTapGestureTutorial:
                return .doubleTap
            case .trippleTapGestureTutorial:
                return .trippleTap
            case .longPressGestureTutorial:
                return .longPress
            case .swipeLeftGestureTutorial:
                return .swipeLeft
            case .swipeRightGestureTutorial:
                return .swipeRight
            case .swipeUpGestureTutorial:
                return .swipeUp
            case .swipeDownGestureTutorial:
                return .swipeDown
            case .longPressAndSwipeLeftGestureTutorial:
                return .longPressAndSwipeLeft
            case .longPressAndSwipeRightGestureTutorial:
                return .longPressAndSwipeRight
            case .longPressAndSwipeUpGestureTutorial:
                return .longPressAndSwipeUp
            case .longPressAndSwipeDownGestureTutorial:
                return .longPressAndSwipeDown
            case .gesturesSectionEnding:
                return nil
            }
        default:
            return nil
        }
    }
}
