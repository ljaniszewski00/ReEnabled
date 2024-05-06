import Lottie
import SwiftUI

extension OnboardingSection {
    var imageResource: (imageResource: ImageResource, width: CGFloat, height: CGFloat, applyBottomMask: Bool)? {
        switch self {
        case .welcome:
            return (.appIconNoBackground, 250, 250, false)
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return nil
            case .tapGestureTutorial:
                return (.singleTapGesture, 250, 250, false)
            case .doubleTapGestureTutorial:
                return (.doubleTapGesture, 250, 250, false)
            case .trippleTapGestureTutorial:
                return (.trippleTapGesture, 250, 250, false)
            case .longPressGestureTutorial:
                return (.longPressGesture, 250, 250, false)
            case .swipeLeftGestureTutorial:
                return (.swipeLeftGesture, 250, 250, false)
            case .swipeRightGestureTutorial:
                return (.swipeRightGesture, 250, 250, false)
            case .swipeUpGestureTutorial:
                return (.swipeUpGesture, 250, 250, false)
            case .swipeDownGestureTutorial:
                return (.swipeDownGesture, 250, 250, false)
            case .longPressAndSwipeLeftGestureTutorial:
                return (.longPressAndSwipeLeftGesture, 250, 250, false)
            case .longPressAndSwipeRightGestureTutorial:
                return (.longPressAndSwipeRightGesture, 250, 250, false)
            case .longPressAndSwipeUpGestureTutorial:
                return (.longPressAndSwipeUpGesture, 250, 250, false)
            case .longPressAndSwipeDownGestureTutorial:
                return (.longPressAndSwipeDownGesture, 250, 250, false)
            case .gesturesSectionEnding:
                return nil
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                return nil
            case .documentScannerTutorial:
                return nil
            case .colorDetectorTutorial:
                return nil
            case .lightDetectorTutorial:
                return nil
            case .chatMessageTutorial:
                return nil
            case .chatImageTutorial:
                return nil
            case .chatDatabaseTutorial:
                return nil
            case .settingsFirstTutorial:
                return nil
            case .settingsSecondTutorial:
                return nil
            case .settingsThirdTutorial:
                return nil
            }
        case .voiceCommands(_):
            return nil
        case .feedback(_):
            return nil
        case .ending:
            return nil
        }
    }
}
