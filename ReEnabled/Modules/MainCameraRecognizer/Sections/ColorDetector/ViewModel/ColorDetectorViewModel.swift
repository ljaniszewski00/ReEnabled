import SwiftUI

final class ColorDetectorViewModel: ObservableObject {
    @Published var detectedColor: UIColor? = .black
    
    private let feedbackManager: FeedbackManager = .shared
    
    var detectedColorName: String? {
        detectedColor?.accessibilityName.capitalized
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
