enum OnboardingGesturesSection {
    case gesturesSectionWelcome
    case tapGestureTutorial
    case doubleTapGestureTutorial
    case trippleTapGestureTutorial
    case longPressGestureTutorial
    case swipeLeftGestureTutorial
    case swipeRightGestureTutorial
    case swipeUpGestureTutorial
    case swipeDownGestureTutorial
    case longPressAndSwipeLeftGestureTutorial
    case longPressAndSwipeRightGestureTutorial
    case longPressAndSwipeUpGestureTutorial
    case longPressAndSwipeDownGestureTutorial
    case gesturesSectionEnding
}

extension OnboardingGesturesSection: CaseIterable {
    static let allCases: [OnboardingGesturesSection] = [
        .gesturesSectionWelcome,
        .tapGestureTutorial,
        .doubleTapGestureTutorial,
        .trippleTapGestureTutorial,
        .longPressGestureTutorial,
        .swipeLeftGestureTutorial,
        .swipeRightGestureTutorial,
        .swipeUpGestureTutorial,
        .swipeDownGestureTutorial,
        .longPressAndSwipeLeftGestureTutorial,
        .longPressAndSwipeRightGestureTutorial,
        .longPressAndSwipeUpGestureTutorial,
        .longPressAndSwipeDownGestureTutorial,
        .gesturesSectionEnding
    ]
}
