import Foundation
import UIKit

class VoiceRecordingManager: ObservableObject {
    @Published var isRecording: Bool = false
    private var speechRecognizer: SpeechRecognizer = SpeechRecognizer(language: .polish)
    
    @MainActor
    var transcript: String {
        speechRecognizer.transcript
    }
    
    @MainActor
    func manageTalking() {
        if isRecording {
            stopTranscribing()
        } else {
            startTranscribing()
        }
    }
    
    @MainActor 
    private func startTranscribing() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        speechRecognizer.transcript.removeAll()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    @MainActor 
    private func stopTranscribing() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        speechRecognizer.stopTranscribing()
        isRecording = false
    }
}
