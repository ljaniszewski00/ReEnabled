import SwiftUI

struct OnboardingView: View {
    @AppStorage(AppStorageKeys.shouldDisplayOnboarding) var shouldDisplayOnboarding: Bool = true
    @EnvironmentObject private var onboardingViewModel: OnboardingViewModel
    
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var voiceRequestor: VoiceRequestor = .shared
    
    var body: some View {
        OnboardingSectionView(section: onboardingViewModel.currentSection,
                              canDisplaySwipeToProceed: !feedbackManager.speechFeedbackIsBeingGenerated)
            .onAppear {
                if onboardingViewModel.currentSection == .welcome && feedbackManager.speechFeedbackIsBeingGenerated {
                    feedbackManager.stopSpeechFeedback()
                }
                
                onboardingViewModel.readCurrentSection()
            }
            .onChange(of: onboardingViewModel.currentSection) { _, _ in
                if feedbackManager.speechFeedbackIsBeingGenerated {
                    feedbackManager.stopSpeechFeedback()
                }
                
                onboardingViewModel.readCurrentSection()
            }
            .onChange(of: feedbackManager.speechFeedbackIsBeingGenerated) { _, isBeingGenerated in
                if onboardingViewModel.currentSection == .welcome && !isBeingGenerated {
                    onboardingViewModel.changeToNextSectionAfterDelay()
                }
            }
            .onChange(of: onboardingViewModel.shouldDismissOnboarding) { _, shouldDismiss in
                shouldDisplayOnboarding = !shouldDismiss
            }
            .onChange(of: voiceRecordingManager.transcript) { _, newTranscript in
                voiceRequestor.getVoiceRequest(from: newTranscript)
            }
            .onChange(of: voiceRequestor.selectedVoiceRequest) { _, voiceRequest in
                guard voiceRequest != VoiceRequest.empty else {
                    return
                }
                
                switch voiceRequest {
                case .onboarding(.readSection):
                    guard onboardingViewModel.currentVoiceRequestToPass == nil else {
                        return
                    }
                    
                    onboardingViewModel.readCurrentSection()
                case .onboarding(.skipOnboarding):
                    guard onboardingViewModel.currentVoiceRequestToPass == nil else {
                        return
                    }
                    
                    onboardingViewModel.exitOnboarding()
                case .onboarding(.nextSection):
                    guard onboardingViewModel.currentVoiceRequestToPass == nil else {
                        return
                    }
                    
                    onboardingViewModel.changeToNextSection()
                case .onboarding(.previousSection):
                    guard onboardingViewModel.currentVoiceRequestToPass == nil else {
                        return
                    }
                    
                    onboardingViewModel.changeToPreviousSection()
                case .other(.remindVoiceCommands):
                    guard onboardingViewModel.currentVoiceRequestToPass == nil else {
                        return
                    }
                    
                    let actionScreen = ActionScreen(screenType: .onboarding)
                    feedbackManager.generateVoiceRequestsReminder(for: actionScreen)
                case .other(.remindGestures):
                    if onboardingViewModel.currentVoiceRequestToPass == .other(.remindGestures) {
                        onboardingViewModel.voiceRequestPromptCompleted()
                    }
                    
                    let actionScreen = ActionScreen(screenType: .onboarding)
                    feedbackManager.generateGesturesReminder(for: actionScreen)
                default:
                    return
                }
            }
            .addGesturesActions(toExecuteBeforeEveryAction: {
                feedbackManager.generateHapticFeedbackForSwipeAction()
            }, onTap: {
                guard onboardingViewModel.currentGestureToPass != .singleTap else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
                
                if feedbackManager.speechFeedbackIsBeingGenerated {
                    feedbackManager.stopSpeechFeedback()
                } else {
                    onboardingViewModel.readCurrentSection()
                }
            }, onDoubleTap: {
                guard onboardingViewModel.currentGestureToPass != .doubleTap else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
            }, onTrippleTap: {
                guard onboardingViewModel.currentGestureToPass != .trippleTap else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
            }, onLongPress: {
                guard onboardingViewModel.currentGestureToPass != .longPress else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
                
                if onboardingViewModel.currentGestureToPass == nil {
                    voiceRecordingManager.manageTalking()
                }
            }, onSwipeFromLeftToRight: {
                guard onboardingViewModel.currentGestureToPass != .swipeRight else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
                
                if onboardingViewModel.currentGestureToPass == nil && onboardingViewModel.currentVoiceRequestToPass == nil {
                    onboardingViewModel.changeToNextSection()
                }
            }, onSwipeFromRightToLeft: {
                guard onboardingViewModel.currentGestureToPass != .swipeLeft else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
                
                if onboardingViewModel.currentGestureToPass == nil && onboardingViewModel.currentVoiceRequestToPass == nil {
                    onboardingViewModel.changeToPreviousSection()
                }
            }, onSwipeFromUpToDown: {
                guard onboardingViewModel.currentGestureToPass != .swipeDown else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
            }, onSwipeFromDownToUp: {
                guard onboardingViewModel.currentGestureToPass != .swipeUp else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
            }, onSwipeFromLeftToRightAfterLongPress: {
                guard onboardingViewModel.currentGestureToPass != .longPressAndSwipeRight else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
            }, onSwipeFromRightToLeftAfterLongPress: {
                guard onboardingViewModel.currentGestureToPass != .longPressAndSwipeLeft else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
            }, onSwipeFromUpToDownAfterLongPress: {
                guard onboardingViewModel.currentGestureToPass != .longPressAndSwipeDown else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
            }, onSwipeFromDownToUpAfterLongPress: {
                guard onboardingViewModel.currentGestureToPass != .longPressAndSwipeUp else {
                    onboardingViewModel.gesturePromptCompleted()
                    return
                }
            })
    }
}

#Preview {
    OnboardingView()
        .environmentObject(OnboardingViewModel())
}
