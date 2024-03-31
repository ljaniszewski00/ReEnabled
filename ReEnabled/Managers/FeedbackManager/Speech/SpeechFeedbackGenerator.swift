import AVFoundation

final class SpeechFeedbackGenerator: SpeechFeedbackGenerating {
    @Inject private var settingsProvider: SettingsProviding
    
    private var speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    private var speechVoice: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(language: SettingsProvider.shared.speechLanguage.languageCode)
    
    func changeVoiceLanguage(to language: SupportedLanguage) {
        self.speechVoice = AVSpeechSynthesisVoice(language: language.languageCode)
    }
    
    func generate(for text: String) {
        if speechSynthesizer.isSpeaking {
            return
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = self.speechVoice
        self.speechSynthesizer.speak(utterance)
    }
}

protocol SpeechFeedbackGenerating {
    func changeVoiceLanguage(to language: SupportedLanguage)
    func generate(for text: String)
}
