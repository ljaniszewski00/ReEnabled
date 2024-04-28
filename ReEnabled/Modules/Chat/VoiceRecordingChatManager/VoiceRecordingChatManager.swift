import Combine
import Foundation
import UIKit

final class VoiceRecordingChatManager: ObservableObject {
    @Inject private var settingsProvider: SettingsProvider
    
    private var speechRecognizer: SpeechRecognizer?
    @Published var isRecordingChatMessage: Bool = false
    
    private var feedbackManager: FeedbackManager = .shared
    
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        guard let voiceRecordingLanguage: SupportedLanguage = getAppLanguage() else {
            return
            
        }
        
        speechRecognizer = SpeechRecognizer(
            language: voiceRecordingLanguage
        )
    }
    
    @MainActor
    var chatMessageTranscript: String {
        speechRecognizer?.transcript ?? ""
    }
    
    @MainActor
    func manageTalking() {
        isRecordingChatMessage ? stopTranscribing() : startTranscribing()
    }
    
    @MainActor
    private func startTranscribing() {
        feedbackManager.generateSpeechFeedback(with: .chat(.whatYouWantToKnow))
        speechRecognizer?.transcript.removeAll()
        isRecordingChatMessage = true
        speechRecognizer?.startTranscribing()
    }
    
    @MainActor
    private func stopTranscribing() {
        speechRecognizer?.stopTranscribing()
        isRecordingChatMessage = false
    }
}
