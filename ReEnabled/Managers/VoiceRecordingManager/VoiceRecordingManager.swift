import Foundation
import UIKit

final class VoiceRecordingManager: ObservableObject {
    @Published var isRecording: Bool = false
    
    private var speechRecognizer: SpeechRecognizer = SpeechRecognizer(language: .english)
    
    private init() {}
    
    static let shared: VoiceRecordingManager = {
        VoiceRecordingManager()
    }()
    
    @MainActor
    var transcript: String {
        speechRecognizer.transcript
    }
    
    @MainActor
    func manageTalking() {
        print("Voice Recording Manager Manage Talking")
        if isRecording {
            stopTranscribing()
        } else {
            startTranscribing()
        }
    }
    
    @MainActor 
    private func startTranscribing() {
        speechRecognizer.transcript.removeAll()
        isRecording = true
        print("Voice Recording Manager Start Transcribing")
        speechRecognizer.startTranscribing()
        
    }
    
    @MainActor 
    private func stopTranscribing() {
        speechRecognizer.stopTranscribing()
        print("Voice Recording Manager Stop Transcribing")
        isRecording = false
    }
}

extension VoiceRecordingManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
