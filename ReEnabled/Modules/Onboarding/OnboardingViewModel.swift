import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentSection: OnboardingSection = .welcome
    @Published var canDisplayActionCompletedAnimation: Bool = false
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
        
        if currentSection.shouldReadTitle,
           let title = currentSection.title {
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
    
    func changeToNextSectionAfterDelay(time: DispatchTime = .now() + 2) {
        DispatchQueue.main.asyncAfter(deadline: time) { [weak self] in
            self?.changeToNextSection()
        }
    }
    
    func gesturePromptCompleted() {
        canDisplayActionCompletedAnimation = true
        changeToNextSectionAfterDelay()
    }
    
    func voiceRequestPromptCompleted() {
        canDisplayActionCompletedAnimation = true
        changeToNextSectionAfterDelay(time: .now() + 5)
    }
    
    func exitOnboarding() {
        feedbackManager.generateSpeechFeedback(with: .onboarding(.onboardingHasBeenCompleted))
        shouldDismissOnboarding = true
    }
}
