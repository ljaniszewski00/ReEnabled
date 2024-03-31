import AVFoundation

final class SpeechFeedbackGenerator: SpeechFeedbackGenerating {
    private var speechSynthesizer: AVSpeechSynthesizer?
    private var speechVoice: AVSpeechSynthesisVoice?
    
    init() {
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.speechVoice = AVSpeechSynthesisVoice(language: SupportedLanguage.polish.languageCode)
    }
    
    func changeVoiceLanguage(to language: SupportedLanguage) {
        self.speechVoice = AVSpeechSynthesisVoice(language: language.languageCode)
    }
    
    func generate(for text: String) {
        if let isSpeaking = self.speechSynthesizer?.isSpeaking {
            if isSpeaking {
                return
            }
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = self.speechVoice
        self.speechSynthesizer?.speak(utterance)
    }
}

protocol SpeechFeedbackGenerating {
    func changeVoiceLanguage(to language: SupportedLanguage)
    func generate(for text: String)
}
