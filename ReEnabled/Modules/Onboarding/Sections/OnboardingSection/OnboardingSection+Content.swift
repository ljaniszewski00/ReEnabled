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
    
    var descriptionContent: some View {
        switch self {
        case .welcome:
            let text: String = """
            We will be more than happy to assist you in everyday tasks.
            First, let’s take a quick tour around app’s essential features
            """
            return Text(text)
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                let text: String = """
                A gesture is a movement made by a finger on the screen surface.
                Most screens of the application have functions that are triggered by specific gestures.
                Let's try to learn them together.
                """
                return Text(text)
            case .tapGestureTutorial:
                let text: String = """
                Tap once with one finger on the screen.
                """
                return Text(text)
            case .doubleTapGestureTutorial:
                let text: String = """
                Quickly tap twice with one finger on the screen.
                """
                return Text(text)
            case .trippleTapGestureTutorial:
                let text: String = """
                Quickly tap three times with one finger on the screen.
                """
                return Text(text)
            case .longPressGestureTutorial:
                let text: String = """
                Hold your finger in one place on the screen and release after a moment.
                """
                return Text(text)
            case .swipeLeftGestureTutorial:
                let text: String = """
                Swipe your finger from the right side of the screen to the left.
                """
                return Text(text)
            case .swipeRightGestureTutorial:
                let text: String = """
                Swipe your finger from the left side of the screen to the right.
                """
                return Text(text)
            case .swipeUpGestureTutorial:
                let text: String = """
                Swipe your finger from the bottom of the screen upwards.
                """
                return Text(text)
            case .swipeDownGestureTutorial:
                let text: String = """
                Swipe your finger from the top of the screen downwards.
                """
                return Text(text)
            case .longPressAndSwipeLeftGestureTutorial:
                let text: String = """
                Hold your finger in one place on the screen, then swipe left and release.
                """
                return Text(text)
            case .longPressAndSwipeRightGestureTutorial:
                let text: String = """
                Hold your finger in one place on the screen, then swipe right and release.
                """
                return Text(text)
            case .longPressAndSwipeUpGestureTutorial:
                let text: String = """
                Hold your finger in one place on the screen, then swipe up and release.
                """
                return Text(text)
            case .longPressAndSwipeDownGestureTutorial:
                let text: String = """
                Hold your finger in one place on the screen, then swipe down and release.
                """
                return Text(text)
            case .gesturesSectionEnding:
                let text: String = """
                From now on during this tutorial you can always
                Single tap to hear current guide section once again after speech has ended
                Swipe Right to get to the next part
                or Swipe left to go back to previous one

                Let's move on to the next part of the guide by swiping right.
                """
                return Text(text)
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                let text: String = """
                It will allow you to explore the world around you by identifying surrounding objects, warning you about approaching obstacles, or signaling red or green lights on the street.
                """
                return Text(text)
            case .documentScannerTutorial:
                let text: String = """
                You can also use it to recognize text from any source and read the contents of barcodes and QR codes.
                """
                return Text(text)
            case .colorDetectorTutorial:
                let text: String = """
                The camera tab will enable you to investigate the dominant color of an object...
                """
                return Text(text)
            case .lightDetectorTutorial:
                let text: String = """
                ...or measure the ambient light level.
                """
                return Text(text)
            case .chatMessageTutorial:
                let text: String = """
                Here, you can get a response to any question using voice messages.
                """
                return Text(text)
            case .chatImageTutorial:
                let text: String = """
                It's also possible to send a photo to get a detailed description of it.
                """
                return Text(text)
            case .chatDatabaseTutorial:
                let text: String = """
                All conversations are always accessible, even after closing the app, unless you decide to delete them.
                """
                return Text(text)
            case .settingsFirstTutorial:
                let text: String = """
                Where you can customize many app options to your preferences.
                """
                return Text(text)
            case .settingsSecondTutorial:
                let text: String = """
                You can change the language and speed of speech, set the flashlight mode, or change the unit of distance to the nearest obstacle on the road.
                """
                return Text(text)
            case .settingsThirdTutorial:
                let text: String = """
                It's also possible to change the default tab activated when the app is launched, delete conversations, and restore all settings to factory defaults.
                """
                return Text(text)
            }
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                let text: String = """
                The application has a built-in set of voice commands for each screen.
                Recording a command is activated by performing a long press gesture until you feel a vibration.
                After finishing speaking, perform the long press gesture again to register and process the command.
                """
                return Text(text)
            case .voiceCommandsRemindGestures:
                let text: String = """
                Hold your finger on the screen for a moment, then release. After feeling the vibration, say:

                "Remind gestures."

                Then, hold your finger again and release after a moment.
                """
                return Text(text)
            case .voiceCommandsRemindVoiceCommands:
                let text: String = """
                3. This way, you've heard the available gestures on that screen.
                Thanks to this, you'll learn all the available gestures on every screen of the application.
                Moreover, you can learn the remaining available voice commands on the screen by performing the same action but issuing a voice command:

                "Remind voice commands."
                """
                return Text(text)
            }
        case .feedback(let onboardingFeedbackSection):
            switch onboardingFeedbackSection {
            case .feedbackFirstTutorial:
                let text: String = """
                It is automatically activated when you perform any action.
                Let's take issuing the gesture reminder command as an example.
                To issue a voice command, you perform a gesture, after which there will be an immediate vibration.
                After issuing the command, the device will read aloud the available gestures, which serves as the voice response.
                """
                return Text(text)
            case .feedbackSecondTutorial:
                let text: String = """
                Some of them are triggered automatically - for example, in the obstacle warning module.
                After getting too close to any object, the device will vibrate and issue a relevant message.
                """
                return Text(text)
            }
        case .ending:
            let text: String = """
            You can always retake this guide by going to Settings tab and choosing appropriate option or just executing voice command:

            „Display Onboarding”

            Swipe right to go to the app or Swipe left to go to previous sections of the guide.
            """
            return Text(text)
        }
    }
}
