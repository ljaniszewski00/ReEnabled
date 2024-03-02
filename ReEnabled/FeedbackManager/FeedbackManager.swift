//
//  Created by Patrick Valenta on 08.10.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import AudioToolbox.AudioServices
import AVFoundation
import Foundation
import UIKit

class FeedbackManager: FeedbackManaging {
    private var hapticTimer: Timer?
    private var speechTimer: Timer?
    
    private var speechSynthesizer: AVSpeechSynthesizer?
    private var speechVoice: AVSpeechSynthesisVoice?
    
    init() {
        self.hapticTimer = Timer()
        self.speechTimer = Timer()
        
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.speechVoice = AVSpeechSynthesisVoice(language: "en-US")
    }
    
    public func start(text: String,
                      withInterval interval: TimeInterval,
                      feedbackType: FeedbackType) {
        DispatchQueue.main.async {
            if feedbackType.sound {
                self.speekText(text: text)
                self.speechTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.doSpeechFeedback), userInfo: ["speech": text], repeats: true)
            }
            
            if feedbackType.vibration {
                self.doHapticFeedback()
                self.hapticTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.doHapticFeedback), userInfo: nil, repeats: true)
            }
        }
        
    }
    
    public func stop() {
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

protocol FeedbackManaging {
    func start(text: String,
               withInterval interval: TimeInterval,
               feedbackType: FeedbackType)
    func stop()
}
