import SwiftUI

final class ColorDetectorViewModel: ObservableObject {
    @Published var detectedColor: UIColor?
    
    private let feedbackManager: FeedbackManager = .shared
    
    var detectedColorName: String? {
        detectedColor?.accessibilityName
    }
    
    func readDetectedColor() {
        if feedbackManager.speechFeedbackIsBeingGenerated {
            feedbackManager.stopSpeechFeedback()
        } else {
            if let colorName = detectedColorName {
                feedbackManager.generateSpeechFeedback(with: colorName)
            }
        }
    }
}
