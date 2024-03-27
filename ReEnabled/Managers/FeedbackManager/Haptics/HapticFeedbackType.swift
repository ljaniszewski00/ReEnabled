import UIKit

enum HapticFeedbackType {
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case impact(HapticImpactFeedbackType)
}

enum HapticImpactFeedbackType {
    case light
    case medium
    case heavy
}
