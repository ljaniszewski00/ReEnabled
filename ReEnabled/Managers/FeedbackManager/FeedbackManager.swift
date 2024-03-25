import AVFoundation
import Foundation
import UIKit

class FeedbackManager: ObservableObject {
    private var hapticTimer: Timer?
    private var speechTimer: Timer?
    private var speechSynthesizer: AVSpeechSynthesizer?
    private var speechVoice: AVSpeechSynthesisVoice?
    
    private init() {
        self.hapticTimer = Timer()
        self.speechTimer = Timer()
        
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.speechVoice = AVSpeechSynthesisVoice(language: SupportedLanguage.polish.languageCode)
    }
    
    static let shared: FeedbackManager = {
        FeedbackManager()
    }()
    
    func changeVoiceLanguage(to language: SupportedLanguage) {
        self.speechVoice = AVSpeechSynthesisVoice(language: language.languageCode)
    }
    
    func startHaptic(withInterval interval: TimeInterval) {
        DispatchQueue.main.async {
            self.doHapticFeedback()
            self.hapticTimer = Timer.scheduledTimer(timeInterval: interval, 
                                                    target: self,
                                                    selector: #selector(self.doHapticFeedback),
                                                    userInfo: nil,
                                                    repeats: true)
        }
    }
    
    func startSpeech(text: String,
                     withInterval interval: TimeInterval) {
        DispatchQueue.main.async {
            self.speekText(text: text)
            self.speechTimer = Timer.scheduledTimer(timeInterval: 3, 
                                                    target: self,
                                                    selector: #selector(self.doSpeechFeedback),
                                                    userInfo: ["speech": text],
                                                    repeats: true)
        }
        
    }
    
    func stop() {
        hapticTimer?.invalidate()
        speechTimer?.invalidate()
    }
    
    @objc private func doHapticFeedback() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    @objc private func doSpeechFeedback(sender: Timer) {
        if let userInfo = sender.userInfo as? Dictionary<String, String>{
            self.speekText(text: userInfo["speech"]!)
        }
    }
    
    private func speekText(text: String) {
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

extension FeedbackManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
