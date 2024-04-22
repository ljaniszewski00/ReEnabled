import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentSection: OnboardingSection = .welcome
    @Published var shouldDismissOnboarding: Bool = false
    
    var currentGestureToPass: GestureType? {
        currentSection.gestureToPass
    }
    
    func changeToPreviousSection() {
        guard let previousSection: OnboardingSection = currentSection.previousSection() else {
            return
        }
        
        currentSection = previousSection
    }
    
    func changeToNextSection() {
        guard let nextSection: OnboardingSection = currentSection.nextSection() else {
            shouldDismissOnboarding = true
            return
        }
        
        currentSection = nextSection
    }
}
