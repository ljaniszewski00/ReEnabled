enum GestureType: CaseIterable {
    case singleTap
    case doubleTap
    case trippleTap
    case longPress
    case swipeRight
    case swipeLeft
    case swipeDown
    case swipeUp
    case longPressAndSwipeRight
    case longPressAndSwipeLeft
    case longPressAndSwipeDown
    case longPressAndSwipeUp
}

extension GestureType {
    var name: String {
        switch self {
        case .singleTap:
            "Single tap"
        case .doubleTap:
            "Double tap"
        case .trippleTap:
            "Tripple tap"
        case .longPress:
            "Long press"
        case .swipeRight:
            "Swipe right"
        case .swipeLeft:
            "Swipe left"
        case .swipeDown:
            "Swipe down"
        case .swipeUp:
            "Swipe up"
        case .longPressAndSwipeRight:
            "Long press and swipe right"
        case .longPressAndSwipeLeft:
            "Long press and swipe left"
        case .longPressAndSwipeDown:
            "Long press and swipe down"
        case .longPressAndSwipeUp:
            "Long press and swipe up"
        }
    }
    
    var instruction: String {
        switch self {
        case .singleTap:
            "Tap one time on the screen"
        case .doubleTap:
            "Tap two times on the screen"
        case .trippleTap:
            "Tap three times on the screen"
        case .longPress:
            "Long press on the screen and release after a while"
        case .swipeRight:
            "Swipe from left to right, then release"
        case .swipeLeft:
            "Swipe from right to left, then release"
        case .swipeDown:
            "Swipe from top to bottom, then release"
        case .swipeUp:
            "Swipe from bottom to top, then release"
        case .longPressAndSwipeRight:
            "Long press on the screen, don't release but swipe from left to right, then release"
        case .longPressAndSwipeLeft:
            "Long press on the screen, don't release but swipe from right to left, then release"
        case .longPressAndSwipeDown:
            "Long press on the screen, don't release but swipe from top to bottom, then release"
        case .longPressAndSwipeUp:
            "Long press on the screen, don't release but swipe from bottom to top, then release"
        }
    }
}
