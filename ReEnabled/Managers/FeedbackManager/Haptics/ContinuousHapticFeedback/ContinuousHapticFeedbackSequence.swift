import Foundation

class ContinuousHapticFeedbackSequence {
    var feedbackSequence: [HapticFeedbackType]
    var delay: Double
    
    init(feedbackSequence: [HapticFeedbackType], delay: Double = 0.8) {
        self.feedbackSequence = feedbackSequence
        self.delay = delay
    }
}
