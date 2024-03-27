import AVFoundation
import Combine
import Foundation
import UIKit

final class FeedbackManager: ObservableObject {
    private var speechSynthesizer: AVSpeechSynthesizer?
    private var speechVoice: AVSpeechSynthesisVoice?
    
    @Published var shouldStartHaptic: Bool = false
    @Published var shouldStartContinuousHaptic: Bool = false
    @Published var shouldStartSpeech: Bool = false
    
    private var cancelBag = Set<AnyCancellable>()
    
    private init() {
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.speechVoice = AVSpeechSynthesisVoice(language: SupportedLanguage.polish.languageCode)
        self.continuousHapticFeedbackGenerator = ContinuousHapticFeedbackGenerator(generator: hapticFeedbackGenerator)
    }
    
    static let shared: FeedbackManager = {
        FeedbackManager()
    }()
    
    // MARK: - Haptic Feedback
    
    private let hapticFeedbackGenerator: HapticFeedbackGenerating = HapticFeedbackGenerator()
    private var continuousHapticFeedbackGenerator: ContinuousHapticFeedbackGenerating?
    
    func generate(_ hapticFeedbackType: HapticFeedbackType) {
        hapticFeedbackGenerator.generate(hapticFeedbackType)
    }
    
    func generateContinuousSequences(_ sequences: [ContinuousHapticFeedbackSequence], 
                                     withDelayBetweenThem intersectionDelay: Double) async {
        if continuousHapticFeedbackGenerator == nil {
            continuousHapticFeedbackGenerator = ContinuousHapticFeedbackGenerator(generator: hapticFeedbackGenerator)
        }
        
        guard let continuousHapticFeedbackGenerator = continuousHapticFeedbackGenerator else {
            return
        }
        
        await continuousHapticFeedbackGenerator.generate(for: sequences, withDelayBetweenThem: intersectionDelay)
    }
    
    func generateHapticFeedbackForMicrophoneUsage() {
        generate(.impact(.medium))
    }
    
    // MARK: - Speech Feedback
    
    func changeVoiceLanguage(to language: SupportedLanguage) {
        self.speechVoice = AVSpeechSynthesisVoice(language: language.languageCode)
    }
    
    func executeSpeechFeedback(text: String) {
        if let isSpeaking = self.speechSynthesizer?.isSpeaking {
            if isSpeaking {
                return
            }
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = self.speechVoice
        self.speechSynthesizer?.speak(utterance)
    }
}

extension FeedbackManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
