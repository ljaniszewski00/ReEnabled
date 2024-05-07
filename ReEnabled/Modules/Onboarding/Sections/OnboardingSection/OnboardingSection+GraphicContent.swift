import Lottie
import SwiftUI

extension OnboardingSection {
    var imageResource: (imageResource: ImageResource, width: CGFloat, height: CGFloat)? {
        switch self {
        case .welcome:
            return (.appIconNoBackground, 250, 250)
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return nil
            case .tapGestureTutorial:
                return (.singleTapGesture, 250, 250)
            case .doubleTapGestureTutorial:
                return (.doubleTapGesture, 250, 250)
            case .trippleTapGestureTutorial:
                return (.trippleTapGesture, 250, 250)
            case .longPressGestureTutorial:
                return (.longPressGesture, 250, 250)
            case .swipeLeftGestureTutorial:
                return (.swipeLeftGesture, 250, 250)
            case .swipeRightGestureTutorial:
                return (.swipeRightGesture, 250, 250)
            case .swipeUpGestureTutorial:
                return (.swipeUpGesture, 250, 250)
            case .swipeDownGestureTutorial:
                return (.swipeDownGesture, 250, 250)
            case .longPressAndSwipeLeftGestureTutorial:
                return (.longPressAndSwipeLeftGesture, 250, 250)
            case .longPressAndSwipeRightGestureTutorial:
                return (.longPressAndSwipeRightGesture, 250, 250)
            case .longPressAndSwipeUpGestureTutorial:
                return (.longPressAndSwipeUpGesture, 250, 250)
            case .longPressAndSwipeDownGestureTutorial:
                return (.longPressAndSwipeDownGesture, 250, 250)
            case .gesturesSectionEnding:
                return nil
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                return (.cameraTabMainRecognizerGreenLight, 150, 150)
            case .documentScannerTutorial:
                return (.cameraTabDocumentScanner, 150, 150)
            case .colorDetectorTutorial:
                return (.cameraTabColorDetector, 150, 150)
            case .lightDetectorTutorial:
                return (.cameraTabLightDetector, 150, 150)
            case .chatMessageTutorial:
                return (.chatTabChatText, 150, 150)
            case .chatImageTutorial:
                return (.chatTabChat, 150, 150)
            case .chatDatabaseTutorial:
                return (.chatTabEmptyConversation, 150, 150)
            case .settingsFirstTutorial:
                return (.settingsTabDefaultDistanceMeasureUnit, 150, 150)
            case .settingsSecondTutorial:
                return (.settingsTabSpeechSpeed, 150, 150)
            case .settingsThirdTutorial:
                return (.settingsTabDefaultCameraMode, 150, 150)
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
