import AVFoundation

final class SpeechFeedbackGenerator: SpeechFeedbackGenerating {
    @Inject private var settingsProvider: SettingsProvider
    
    private let backgroundQueue = DispatchQueue(label: "speechFeedbackGeneratorQueue",
                                                qos: .userInteractive)
    
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
    
    var isSpeaking: Bool {
        speechSynthesizer.isSpeaking
    }
    
    func generate(for text: String) {
        guard !speechSynthesizer.isSpeaking else {
            return
        }
        
        backgroundQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.playback, mode: .default)
            } catch {
                return
            }
            
            DispatchQueue.main.async {
                let utterance = AVSpeechUtterance(string: text)
                utterance.voice = self.speechVoice
                utterance.rate = self.settingsProvider.speechSpeed
                
                self.speechSynthesizer.speak(utterance)
            }
        }
    }
    
    func generateSample() {
        let sampleText: String = settingsProvider.speechLanguage.getSpeechVoiceSampleText(voiceName: currentSpeechVoiceName)
        generate(for: sampleText)
    }
    
    func stopGenerating() {
        guard speechSynthesizer.isSpeaking else {
            return
        }
        
        speechSynthesizer.stopSpeaking(at: .word)
    }
}

protocol SpeechFeedbackGenerating {
    var isSpeaking: Bool { get }
    
    func generate(for text: String)
    func generateSample()
    func stopGenerating()
}
