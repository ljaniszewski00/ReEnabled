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
        case .singleTap: OtherText.gestureTypeSingleTapName.rawValue.localized()
        case .doubleTap: OtherText.gestureTypeDoubleTapName.rawValue.localized()
        case .trippleTap: OtherText.gestureTypeTrippleTapName.rawValue.localized()
        case .longPress: OtherText.gestureTypeLongPressName.rawValue.localized()
        case .swipeRight: OtherText.gestureTypeSwipeRightName.rawValue.localized()
        case .swipeLeft: OtherText.gestureTypeSwipeLeftName.rawValue.localized()
        case .swipeDown: OtherText.gestureTypeSwipeDownName.rawValue.localized()
        case .swipeUp: OtherText.gestureTypeSwipeUpName.rawValue.localized()
        case .longPressAndSwipeRight: OtherText.gestureTypeLongPressAndSwipeRightName.rawValue.localized()
        case .longPressAndSwipeLeft: OtherText.gestureTypeLongPressAndSwipeLeftName.rawValue.localized()
        case .longPressAndSwipeDown: OtherText.gestureTypeLongPressAndSwipeDownName.rawValue.localized()
        case .longPressAndSwipeUp: OtherText.gestureTypeLongPressAndSwipeUpName.rawValue.localized()
        }
    }
    
    var instruction: String {
        switch self {
        case .singleTap: OtherText.gestureTypeSingleTapInstruction.rawValue.localized()
        case .doubleTap: OtherText.gestureTypeDoubleTapInstruction.rawValue.localized()
        case .trippleTap: OtherText.gestureTypeTrippleTapInstruction.rawValue.localized()
        case .longPress: OtherText.gestureTypeLongPressInstruction.rawValue.localized()
        case .swipeRight: OtherText.gestureTypeSwipeRightInstruction.rawValue.localized()
        case .swipeLeft: OtherText.gestureTypeSwipeLeftInstruction.rawValue.localized()
        case .swipeDown: OtherText.gestureTypeSwipeDownInstruction.rawValue.localized()
        case .swipeUp: OtherText.gestureTypeSwipeUpInstruction.rawValue.localized()
        case .longPressAndSwipeRight: OtherText.gestureTypeLongPressAndSwipeRightInstruction.rawValue.localized()
        case .longPressAndSwipeLeft: OtherText.gestureTypeLongPressAndSwipeLeftInstruction.rawValue.localized()
        case .longPressAndSwipeDown: OtherText.gestureTypeLongPressAndSwipeDownInstruction.rawValue.localized()
        case .longPressAndSwipeUp: OtherText.gestureTypeLongPressAndSwipeUpInstruction.rawValue.localized()
        }
    }
}
