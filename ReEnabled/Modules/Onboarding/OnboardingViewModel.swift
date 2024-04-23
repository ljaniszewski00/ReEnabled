import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentSection: OnboardingSection = .welcome
    @Published var shouldDismissOnboarding: Bool = false
    
    private var feedbackManager: FeedbackManager = .shared
    
    var currentGestureToPass: GestureType? {
        currentSection.gestureToPass
    }
    
    var currentVoiceRequestToPass: VoiceRequest? {
        currentSection.voiceRequestToPass
    }
    
    func readCurrentSection() {
        var text: String = ""
        
        if let title = currentSection.title {
            text += title
        }
        
        text += currentSection.description
        
        feedbackManager.generateSpeechFeedback(with: text)
    }
    
    func changeToPreviousSection() {
        guard let previousSection: OnboardingSection = currentSection.previousSection() else {
            return
        }
        
        currentSection = previousSection
    }
    
    func changeToNextSection() {
        guard let nextSection: OnboardingSection = currentSection.nextSection() else {
            exitOnboarding()
            return
        }
        
        currentSection = nextSection
    }
    
    func gesturePromptCompleted() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.changeToNextSection()
        }
    }
    
    func voiceRequestPromptCompleted() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.changeToNextSection()
        }
    }
    
    func exitOnboarding() {
        feedbackManager.generateSpeechFeedback(with: .onboarding(.onboardingHasBeenCompleted))
        shouldDismissOnboarding = true
    }
}
