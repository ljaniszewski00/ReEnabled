import Foundation

final class FeedbackManager: ObservableObject {
    
    static let shared: FeedbackManager = {
        FeedbackManager()
    }()
    
    // MARK: - Haptic Feedback
    
    @Inject var hapticFeedbackGenerator: HapticFeedbackGenerating
    @Inject var continuousHapticFeedbackGenerator: ContinuousHapticFeedbackGenerating
    
    func generateHapticFeedback(_ hapticFeedbackType: HapticFeedbackType) {
        hapticFeedbackGenerator.generate(hapticFeedbackType)
    }
    
    func generateHapticFeedbackContinuousSequences(_ sequences: [ContinuousHapticFeedbackSequence], 
                                                   withDelayBetweenThem intersectionDelay: Double) async {
        await continuousHapticFeedbackGenerator.generate(for: sequences, withDelayBetweenThem: intersectionDelay)
    }
    
    func generateHapticFeedbackForSwipeAction() {
        generateHapticFeedback(.impact(.medium))
    }
    
    // MARK: - Speech Feedback
    
    @Inject var speechFeedbackGenerator: SpeechFeedbackGenerating
    
    func generateSpeechFeedback(with text: String) {
        print(text)
        speechFeedbackGenerator.generate(for: text)
    }
    
    func generateSpeechFeedback(with speechFeedbackText: SpeechFeedback) {
        print(speechFeedbackText.rawValue)
        speechFeedbackGenerator.generate(for: speechFeedbackText.rawValue)
    }
    
    func generateSpeechFeedback(with speechFeedback: SpeechFeedback, and text: String) {
        let speechText: String = "\(speechFeedback.rawValue)\n\(text)"
        print(speechText)
        speechFeedbackGenerator.generate(for: speechText)
    }
    
    func generateSampleSpeechFeedback() {
        speechFeedbackGenerator.generateSample()
    }
}

extension FeedbackManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
