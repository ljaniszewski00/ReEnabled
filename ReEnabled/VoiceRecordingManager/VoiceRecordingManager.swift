import Foundation

class VoiceRecordingManager: ObservableObject {
    @Published var isRecording: Bool = false
    private var speechRecognizer: SpeechRecognizer = SpeechRecognizer(language: .polish)
    
    @MainActor
    var transcript: String {
        speechRecognizer.transcript
    }
    
    @MainActor 
    func startTranscribing() {
        speechRecognizer.transcript.removeAll()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    @MainActor 
    func stopTranscribing() {
        speechRecognizer.stopTranscribing()
        isRecording = false
    }
}
