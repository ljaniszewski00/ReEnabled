import Combine
import Foundation
import SwiftUI
import UIKit

class VoiceRecordingManager: ObservableObject {
    @Inject private var settingsProvider: SettingsProvider
    
    private var speechRecognizer: SpeechRecognizer?
    @Published var isRecording: Bool = false
    
    private var feedbackManager: FeedbackManager = .shared
    
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private init() {
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
    
    static let shared: VoiceRecordingManager = {
        VoiceRecordingManager()
    }()
    
    @MainActor
    var transcript: String {
        speechRecognizer?.transcript ?? ""
    }
    
    @MainActor
    func manageTalking() {
        isRecording ? stopTranscribing() : startTranscribing()
    }
    
    @MainActor 
    private func startTranscribing() {
        feedbackManager.generateSpeechFeedback(with: .other(.whatYouWantMeToDo))
        speechRecognizer?.transcript.removeAll()
        isRecording = true
        speechRecognizer?.startTranscribing()
    }
    
    @MainActor 
    private func stopTranscribing() {
        speechRecognizer?.stopTranscribing()
        isRecording = false
    }
}

extension VoiceRecordingManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
