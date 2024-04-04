import AVFoundation

final class SpeechFeedbackGenerator: SpeechFeedbackGenerating {
    @Inject private var settingsProvider: SettingsProvider
    
    private var currentSpeechVoiceName: String? {
        let speechLanguage: SupportedLanguage = settingsProvider.speechLanguage
        return settingsProvider.speechVoiceType.getVoiceName(for: speechLanguage)
    }
    
    private var currentSpeechVoiceIdentifier: String? {
        let speechLanguage: SupportedLanguage = settingsProvider.speechLanguage
        return settingsProvider.speechVoiceType.getVoiceIdentifier(for: speechLanguage)
    }
    
    private var speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    private var speechVoice: AVSpeechSynthesisVoice? {
        guard let currentSpeechVoiceIdentifier = currentSpeechVoiceIdentifier else {
            return nil
        }
        
        return AVSpeechSynthesisVoice(identifier: currentSpeechVoiceIdentifier)
    }
    
    func generate(for text: String) {
        guard !speechSynthesizer.isSpeaking else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        } catch {
            return
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = self.speechVoice
        utterance.rate = settingsProvider.speechSpeed
        
        speechSynthesizer.speak(utterance)
    }
    
    func generateSample() {
        let sampleText: String = settingsProvider.speechLanguage.getSpeechVoiceSampleText(voiceName: currentSpeechVoiceName)
        generate(for: sampleText)
    }
}

protocol SpeechFeedbackGenerating {
    func generate(for text: String)
    func generateSample()
}
