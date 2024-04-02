import Foundation
import UIKit

final class VoiceRecordingChatManager: ObservableObject {
    @Published var isRecordingChatMessage: Bool = false
    
    private var speechRecognizer: SpeechRecognizer = SpeechRecognizer(language: .polish)
    
    @MainActor
    var chatMessageTranscript: String {
        speechRecognizer.transcript
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
        speechRecognizer.transcript.removeAll()
        isRecordingChatMessage = true
        speechRecognizer.startTranscribing()
        
    }
    
    @MainActor
    private func stopTranscribing() {
        speechRecognizer.stopTranscribing()
        isRecordingChatMessage = false
    }
}
