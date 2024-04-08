import Combine
import Foundation
import UIKit

final class VoiceRecordingChatManager: ObservableObject {
    @Inject private var settingsProvider: SettingsProvider
    
    @Published var isRecordingChatMessage: Bool = false
    
    private var speechRecognizer: SpeechRecognizer?
    
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
        if isRecordingChatMessage {
            stopTranscribing()
        } else {
            startTranscribing()
        }
    }
    
    @MainActor
    private func startTranscribing() {
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
