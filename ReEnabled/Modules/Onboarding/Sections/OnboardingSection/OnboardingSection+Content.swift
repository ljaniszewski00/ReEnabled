import SwiftUI

extension OnboardingSection {
    var title: String? {
        switch self {
        case .welcome:
            return "Welcome to the ReEnabled family"
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return "One of the most important features facilitating the use of the application are gestures."
            case .tapGestureTutorial:
                return "Tap"
            case .doubleTapGestureTutorial:
                return "Double Tap"
            case .trippleTapGestureTutorial:
                return "Triple Tap"
            case .longPressGestureTutorial:
                return "Long Press"
            case .swipeLeftGestureTutorial:
                return "Swipe Left"
            case .swipeRightGestureTutorial:
                return "Swipe Right"
            case .swipeUpGestureTutorial:
                return "Swipe Up"
            case .swipeDownGestureTutorial:
                return "Swipe Down"
            case .longPressAndSwipeLeftGestureTutorial:
                return "Long Press and Swipe Left"
            case .longPressAndSwipeRightGestureTutorial:
                return "Long Press and Swipe Right"
            case .longPressAndSwipeUpGestureTutorial:
                return "Long Press and Swipe Up"
            case .longPressAndSwipeDownGestureTutorial:
                return "Long Press and Swipe Down"
            case .gesturesSectionEnding:
                return "Great! You've learned all the gestures supported by the application."
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                return "The app consists of three tabs. The first one is the camera tab."
            case .documentScannerTutorial:
                return nil
            case .colorDetectorTutorial:
                return nil
            case .lightDetectorTutorial:
                return nil
            case .chatMessageTutorial:
                return "The second one is the chat tab."
            case .chatImageTutorial:
                return nil
            case .chatDatabaseTutorial:
                return nil
            case .settingsFirstTutorial:
                return "Last but not least is the settings tab."
            case .settingsSecondTutorial:
                return nil
            case .settingsThirdTutorial:
                return nil
            }
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                return "On each screen, you can also issue voice commands."
            case .voiceCommandsRemindGestures:
                return "Let's try it now!"
            case .voiceCommandsRemindVoiceCommands:
                return nil
            }
        case .feedback(let onboardingFeedbackSection):
            switch onboardingFeedbackSection {
            case .feedbackFirstTutorial:
                return "The last major part of the application is the vibration and voice response system."
            case .feedbackSecondTutorial:
                return "Most actions in the application are signaled by vibration and the corresponding voice response."
            }
        case .ending:
            return "This would be all from the tutorial. Hope you will find the app very useful during your everyday life."
        }
    }
    
    var image: UIImage? {
        switch self {
        case .welcome:
            return nil
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
    
    var description: String {
        switch self {
        case .welcome:
            return """
            We will be more than happy to assist you in everyday tasks.
            First, let’s take a quick tour around app’s essential features
            """
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return """
                A gesture is a movement made by a finger on the screen surface.
                Most screens of the application have functions that are triggered by specific gestures.
                Let's try to learn them together.
                """
            case .tapGestureTutorial:
                return """
                Tap once with one finger on the screen.
                
                You can use tap once gesture to pause the reading of current onboarding section or to read it again
                """
            case .doubleTapGestureTutorial:
                return """
                Quickly tap twice with one finger on the screen.
                """
            case .trippleTapGestureTutorial:
                return """
                Quickly tap three times with one finger on the screen.
                """
            case .longPressGestureTutorial:
                return """
                Hold your finger in one place on the screen and release after a moment.
                """
            case .swipeLeftGestureTutorial:
                return """
                Swipe your finger from the right side of the screen to the left.
                """
            case .swipeRightGestureTutorial:
                return """
                Swipe your finger from the left side of the screen to the right.
                """
            case .swipeUpGestureTutorial:
                return """
                Swipe your finger from the bottom of the screen upwards.
                """
            case .swipeDownGestureTutorial:
                return """
                Swipe your finger from the top of the screen downwards.
                """
            case .longPressAndSwipeLeftGestureTutorial:
                return """
                Hold your finger in one place on the screen, then swipe left and release.
                """
            case .longPressAndSwipeRightGestureTutorial:
                return """
                Hold your finger in one place on the screen, then swipe right and release.
                """
            case .longPressAndSwipeUpGestureTutorial:
                return """
                Hold your finger in one place on the screen, then swipe up and release.
                """
            case .longPressAndSwipeDownGestureTutorial:
                return """
                Hold your finger in one place on the screen, then swipe down and release.
                """
            case .gesturesSectionEnding:
                return """
                From now on during this tutorial you can always
                Single tap to hear current guide section once again after speech has ended
                Swipe Right to get to the next part
                or Swipe left to go back to previous one

                Let's move on to the next part of the guide by swiping right.
                """
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                return """
                It will allow you to explore the world around you by identifying surrounding objects, warning you about approaching obstacles, or signaling red or green lights on the street.
                """
            case .documentScannerTutorial:
                return """
                You can also use it to recognize text from any source and read the contents of barcodes and QR codes.
                """
            case .colorDetectorTutorial:
                return """
                The camera tab will enable you to investigate the dominant color of an object...
                """
            case .lightDetectorTutorial:
                return """
                ...or measure the ambient light level.
                """
            case .chatMessageTutorial:
                return """
                Here, you can get a response to any question using voice messages.
                """
            case .chatImageTutorial:
                return """
                It's also possible to send a photo to get a detailed description of it.
                """
            case .chatDatabaseTutorial:
                return """
                All conversations are always accessible, even after closing the app, unless you decide to delete them.
                """
            case .settingsFirstTutorial:
                return """
                Where you can customize many app options to your preferences.
                """
            case .settingsSecondTutorial:
                return """
                You can change the language and speed of speech, set the flashlight mode, or change the unit of distance to the nearest obstacle on the road.
                """
            case .settingsThirdTutorial:
                return """
                It's also possible to change the default tab activated when the app is launched, delete conversations, and restore all settings to factory defaults.
                """
            }
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                return """
                The application has a built-in set of voice commands for each screen.
                Recording a command is activated by performing a long press gesture until you feel a vibration.
                After finishing speaking, perform the long press gesture again to register and process the command.
                """
            case .voiceCommandsRemindGestures:
                return """
                Hold your finger on the screen for a moment, then release. After feeling the vibration, say:

                "Remind gestures."

                Then, hold your finger again and release after a moment.
                """
            case .voiceCommandsRemindVoiceCommands:
                return """
                This way, you've heard the available gestures on that screen.
                Thanks to this, you'll learn all the available gestures on every screen of the application.
                Moreover, you can learn the remaining available voice commands on the screen by performing the same action but issuing a voice command:

                "Remind voice commands."
                """
            }
        case .feedback(let onboardingFeedbackSection):
            switch onboardingFeedbackSection {
            case .feedbackFirstTutorial:
                return """
                It is automatically activated when you perform any action.
                Let's take issuing the gesture reminder command as an example.
                To issue a voice command, you perform a gesture, after which there will be an immediate vibration.
                After issuing the command, the device will read aloud the available gestures, which serves as the voice response.
                """
            case .feedbackSecondTutorial:
                return """
                Some of them are triggered automatically - for example, in the obstacle warning module.
                After getting too close to any object, the device will vibrate and issue a relevant message.
                """
            }
        case .ending:
            return """
            You can always retake this guide by going to Settings tab and choosing appropriate option or just executing voice command:

            „Display Onboarding”

            Swipe right to go to the app or Swipe left to go to previous sections of the guide.
            """
        }
    }

}
