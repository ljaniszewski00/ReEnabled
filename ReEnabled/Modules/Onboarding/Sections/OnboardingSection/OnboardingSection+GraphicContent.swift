import Lottie
import SwiftUI

extension OnboardingSection {
    var imageResource: ImageResource? {
        switch self {
        case .welcome:
            return .appIconNoBackground
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return nil
            case .tapGestureTutorial:
                return nil
            case .doubleTapGestureTutorial:
                return nil
            case .trippleTapGestureTutorial:
                return nil
            case .longPressGestureTutorial:
                return nil
            case .swipeLeftGestureTutorial:
                return nil
            case .swipeRightGestureTutorial:
                return nil
            case .swipeUpGestureTutorial:
                return nil
            case .swipeDownGestureTutorial:
                return nil
            case .longPressAndSwipeLeftGestureTutorial:
                return nil
            case .longPressAndSwipeRightGestureTutorial:
                return nil
            case .longPressAndSwipeUpGestureTutorial:
                return nil
            case .longPressAndSwipeDownGestureTutorial:
                return nil
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
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                return nil
            case .voiceCommandsRemindGestures:
                return nil
            case .voiceCommandsRemindVoiceCommands:
                return nil
            }
        case .feedback(let onboardingFeedbackSection):
            switch onboardingFeedbackSection {
            case .feedbackFirstTutorial:
                return nil
            case .feedbackSecondTutorial:
                return nil
            }
        case .ending:
            return nil
        }
    }
    
    var lottieView: LottieView? {
        switch self {
        case .welcome:
            return nil
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return nil
            case .tapGestureTutorial:
                return LottieView(name: LottieAssetName.tapGesture)
            case .doubleTapGestureTutorial:
                return nil
            case .trippleTapGestureTutorial:
                return nil
            case .longPressGestureTutorial:
                return LottieView(name: LottieAssetName.longPressGesture)
            case .swipeLeftGestureTutorial:
                return LottieView(name: LottieAssetName.swipeLeftGesture)
            case .swipeRightGestureTutorial:
                return LottieView(name: LottieAssetName.swipeRightGesture)
            case .swipeUpGestureTutorial:
                return LottieView(name: LottieAssetName.swipeLeftGesture, rotationAngleDegrees: 90)
            case .swipeDownGestureTutorial:
                return LottieView(name: LottieAssetName.swipeLeftGesture, rotationAngleDegrees: 270)
            case .longPressAndSwipeLeftGestureTutorial:
                return nil
            case .longPressAndSwipeRightGestureTutorial:
                return nil
            case .longPressAndSwipeUpGestureTutorial:
                return nil
            case .longPressAndSwipeDownGestureTutorial:
                return nil
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
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                return nil
            case .voiceCommandsRemindGestures:
                return nil
            case .voiceCommandsRemindVoiceCommands:
                return nil
            }
        case .feedback(let onboardingFeedbackSection):
            switch onboardingFeedbackSection {
            case .feedbackFirstTutorial:
                return nil
            case .feedbackSecondTutorial:
                return nil
            }
        case .ending:
            return nil
        }
    }
}
