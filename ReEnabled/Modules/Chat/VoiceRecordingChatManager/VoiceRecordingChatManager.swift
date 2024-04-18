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
        speechRecognizer = SpeechRecognizer(
            language: settingsProvider.voiceRecordingLanguage
        )
        
        observeVoiceRecordingLanguageChanges()
    }
    
    private func observeVoiceRecordingLanguageChanges() {
        settingsProvider.$currentSettings
            .sink { [weak self] newSettings in
                guard let self = self else { return }
                
                Task { [self] in
                    await self.speechRecognizer?.changeLanguage(to: newSettings.voiceRecordingLanguage)
                }
            }
            .store(in: &cancelBag)
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
