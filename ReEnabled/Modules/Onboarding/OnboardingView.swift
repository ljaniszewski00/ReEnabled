import SwiftUI

struct OnboardingView: View {
    @AppStorage(AppStorageData.shouldDisplayOnboarding.rawValue) var shouldDisplayOnboarding: Bool = true
    @EnvironmentObject private var onboardingViewModel: OnboardingViewModel
    
    @StateObject private var feedbackManager: FeedbackManager = .shared
    
    var body: some View {
        OnboardingSectionView(title: onboardingViewModel.currentSection.title,
                              image: onboardingViewModel.currentSection.image) {
            onboardingViewModel.currentSection.descriptionContent
        }
        .onChange(of: onboardingViewModel.shouldDismissOnboarding) { _, shouldDismiss in
            shouldDisplayOnboarding = shouldDismiss
        }
        .addGesturesActions(toExecuteBeforeEveryAction: {
            feedbackManager.generateHapticFeedbackForSwipeAction()
        }, onTap: {
            guard onboardingViewModel.currentGestureToPass != .singleTap else {
                onboardingViewModel.changeToNextSection()
                return
            }
        }, onDoubleTap: {
            guard onboardingViewModel.currentGestureToPass != .doubleTap else {
                onboardingViewModel.changeToNextSection()
                return
            }
        }, onTrippleTap: {
            guard onboardingViewModel.currentGestureToPass != .trippleTap else {
                onboardingViewModel.changeToNextSection()
                return
            }
        }, onLongPress: {
            guard onboardingViewModel.currentGestureToPass != .longPress else {
                onboardingViewModel.changeToNextSection()
                return
            }
        }, onSwipeFromLeftToRight: {
            guard onboardingViewModel.currentGestureToPass != .swipeRight else {
                onboardingViewModel.changeToNextSection()
                return
            }
            
            if onboardingViewModel.currentGestureToPass == nil {
                onboardingViewModel.changeToNextSection()
            }
        }, onSwipeFromRightToLeft: {
            guard onboardingViewModel.currentGestureToPass != .swipeLeft else {
                onboardingViewModel.changeToNextSection()
                return
            }
            
            if onboardingViewModel.currentGestureToPass == nil {
                onboardingViewModel.changeToPreviousSection()
            }
        }, onSwipeFromUpToDown: {
            guard onboardingViewModel.currentGestureToPass != .swipeDown else {
                onboardingViewModel.changeToNextSection()
                return
            }
        }, onSwipeFromDownToUp: {
            guard onboardingViewModel.currentGestureToPass != .swipeUp else {
                onboardingViewModel.changeToNextSection()
                return
            }
        }, onSwipeFromLeftToRightAfterLongPress: {
            guard onboardingViewModel.currentGestureToPass != .longPressAndSwipeRight else {
                onboardingViewModel.changeToNextSection()
                return
            }
        }, onSwipeFromRightToLeftAfterLongPress: {
            guard onboardingViewModel.currentGestureToPass != .longPressAndSwipeLeft else {
                onboardingViewModel.changeToNextSection()
                return
            }
        }, onSwipeFromUpToDownAfterLongPress: {
            guard onboardingViewModel.currentGestureToPass != .longPressAndSwipeDown else {
                onboardingViewModel.changeToNextSection()
                return
            }
        }, onSwipeFromDownToUpAfterLongPress: {
            guard onboardingViewModel.currentGestureToPass != .longPressAndSwipeUp else {
                onboardingViewModel.changeToNextSection()
                return
            }
        })
    }
}

#Preview {
    OnboardingView()
        .environmentObject(OnboardingViewModel())
}
