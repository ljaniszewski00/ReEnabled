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
    
    var isSpeaking: Bool {
        speechSynthesizer.isSpeaking
    }
    
    func generate(for text: String) {
        guard !speechSynthesizer.isSpeaking else {
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .voicePrompt)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            return
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = self.speechVoice
        utterance.rate = self.settingsProvider.speechSpeed
        
        self.speechSynthesizer.speak(utterance)
    }
    
    func generateVoiceRequestsReminder(for actionScreen: ActionScreen) {
        var text: String = OtherSpeechFeedback.youCanUseFollowingVoiceCommands.rawValue
        for availableVoiceRequest in actionScreen.screenType.availableVoiceRequests {
            text += availableVoiceRequest.rawValue
        }
        
        generate(for: text)
    }
    
    func generateGesturesReminder(for actionScreen: ActionScreen) {
        var text: String = OtherSpeechFeedback.youCanUseFollowingGestures.rawValue
        for gestureType in actionScreen.screenType.availableGestures {
            guard let action = actionScreen.gesturesActions[gestureType] else {
                continue
            }
            
            text += gestureType.name
            text += " to "
            text += action.description
        }
        
        generate(for: text)
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
    func generateVoiceRequestsReminder(for actionScreen: ActionScreen)
    func generateGesturesReminder(for actionScreen: ActionScreen)
    func generateSample()
    func stopGenerating()
}
