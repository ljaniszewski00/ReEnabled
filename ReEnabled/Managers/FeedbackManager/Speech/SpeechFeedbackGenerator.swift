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
    
    private let speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    private var speechVoice: AVSpeechSynthesisVoice? {
        guard let currentSpeechVoiceIdentifier = currentSpeechVoiceIdentifier else {
            return nil
        }
        
        return AVSpeechSynthesisVoice(identifier: currentSpeechVoiceIdentifier)
    }
    
    func generate(for text: String) {
        if speechSynthesizer.isSpeaking {
            return
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = self.speechVoice
        utterance.rate = settingsProvider.speechSpeed
        
        self.speechSynthesizer.speak(utterance)
    }
    
    func generateSample() {
        var sampleText: String = settingsProvider.speechLanguage.getSpeechVoiceSampleText(voiceName: currentSpeechVoiceName)
        generate(for: sampleText)
    }
}

protocol SpeechFeedbackGenerating {
    func generate(for text: String)
    func generateSample()
}
