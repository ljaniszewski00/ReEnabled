extension ActionScreenType {
    var availableGestures: [GestureType] {
        switch self {
        case .mainRecognizer:
            [
                .singleTap,
                .doubleTap,
                .trippleTap,
                .longPress,
                .swipeLeft,
                .swipeRight,
                .longPressAndSwipeLeft,
                .longPressAndSwipeRight
            ]
        case .documentScanner:
            [
                .singleTap,
                .doubleTap,
                .trippleTap,
                .longPress,
                .swipeLeft,
                .swipeRight,
                .longPressAndSwipeLeft,
                .longPressAndSwipeRight
            ]
        case .colorDetector:
            [
                .singleTap,
                .doubleTap,
                .trippleTap,
                .longPress,
                .swipeLeft,
                .swipeRight,
                .longPressAndSwipeLeft,
                .longPressAndSwipeRight
            ]
        case .lightDetector:
            [
                .singleTap,
                .doubleTap,
                .trippleTap,
                .longPress,
                .swipeLeft,
                .swipeRight,
                .longPressAndSwipeLeft,
                .longPressAndSwipeRight
            ]
        case .chat:
            [
                .singleTap,
                .doubleTap,
                .longPress,
                .swipeLeft,
                .swipeRight,
                .longPressAndSwipeLeft,
                .longPressAndSwipeRight,
                .longPressAndSwipeUp,
                .longPressAndSwipeDown
            ]
        case .settings:
            [
                .singleTap,
                .doubleTap,
                .trippleTap,
                .longPress,
                .longPressAndSwipeLeft,
                .longPressAndSwipeRight
            ]
        case .onboarding:
            [
                .singleTap,
                .longPress,
                .swipeLeft,
                .swipeRight,
                
            ]
        }
    }
}
