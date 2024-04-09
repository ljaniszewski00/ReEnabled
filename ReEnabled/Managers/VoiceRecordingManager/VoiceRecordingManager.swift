import Combine
import Foundation
import SwiftUI
import UIKit

final class VoiceRecordingManager: ObservableObject {
    @Inject private var settingsProvider: SettingsProvider
    
    @Published var isRecording: Bool = false
    @Published var shouldDisplayVoiceCommandPreviewView: Bool = false
    
    private var speechRecognizer: SpeechRecognizer?
    
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
    
    func enableVoiceCommandPreviewView() {
        withAnimation {
            shouldDisplayVoiceCommandPreviewView = true
        }
    }
    
    func disableVoiceCommandPreviewView() {
        withAnimation {
            shouldDisplayVoiceCommandPreviewView = false
        }
    }
    
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
