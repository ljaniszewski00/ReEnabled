extension OnboardingSection {
    var title: String? {
        switch self {
        case .welcome:
            return OnboardingText.titleWelcomeSectionWelcomeText.rawValue.localized()
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return OnboardingText.titleGesturesSectionWelcomeText.rawValue.localized()
            case .tapGestureTutorial:
                return "SINGLE TAP"
            case .doubleTapGestureTutorial:
                return "DOUBLE TAP"
            case .trippleTapGestureTutorial:
                return "TRIPLE TAP"
            case .longPressGestureTutorial:
                return "LONG PRESS"
            case .swipeLeftGestureTutorial:
                return "SWIPE LEFT"
            case .swipeRightGestureTutorial:
                return "SWIPE RIGHT"
            case .swipeUpGestureTutorial:
                return "SWIPE UP"
            case .swipeDownGestureTutorial:
                return "SWIPE DOWN"
            case .longPressAndSwipeLeftGestureTutorial:
                return "LONG PRESS AND SWIPE LEFT"
            case .longPressAndSwipeRightGestureTutorial:
                return "LONG PRESS AND SWIPE RIGHT"
            case .longPressAndSwipeUpGestureTutorial:
                return "LONG PRESS AND SWIPE UP"
            case .longPressAndSwipeDownGestureTutorial:
                return "LONG PRESS AND SWIPE DOWN"
            case .gesturesSectionEnding:
                return "GREAT!"
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                return """
                CAMERA TAB
                """
            case .documentScannerTutorial:
                return """
                CAMERA TAB
                """
            case .colorDetectorTutorial:
                return """
                CAMERA TAB
                """
            case .lightDetectorTutorial:
                return """
                CAMERA TAB
                """
            case .chatMessageTutorial:
                return """
                CHAT TAB
                """
            case .chatImageTutorial:
                return """
                CHAT TAB
                """
            case .chatDatabaseTutorial:
                return """
                CHAT TAB
                """
            case .settingsFirstTutorial:
                return """
                SETTING TAB
                """
            case .settingsSecondTutorial:
                return """
                SETTING TAB
                """
            case .settingsThirdTutorial:
                return """
                SETTING TAB
                """
            }
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                return "VOICE COMMANDS"
            case .voiceCommandsRemindGestures:
                return "VOICE COMMANDS"
            case .voiceCommandsRemindVoiceCommands:
                return "VOICE COMMANDS"
            }
        case .feedback(let onboardingFeedbackSection):
            switch onboardingFeedbackSection {
            case .feedbackFirstTutorial:
                return "FEEDBACK MODULE"
            case .feedbackSecondTutorial:
                return "FEEDBACK MODULE"
            }
        case .ending:
            return """
            PERFECT!
            """
        }
    }
    
    var description: String {
        switch self {
        case .welcome:
            return OnboardingText.descriptionWelcomeSectionWelcomeText.rawValue.localized()
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return """
                One of the most important features facilitating the use of the application are gestures.
                A gesture is a movement made by a finger on the screen surface.
                Most screens of the application have functions that are triggered by specific gestures.
                Let's try to learn them together.
                """
            case .tapGestureTutorial:
                return """
                Tap once with one finger on the screen.
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
                You've learned all the gestures supported by the application.
                From now on during this tutorial you can always:
                
                Single tap to hear current guide section once again after speech has ended
                
                Swipe Right to get to the next part
                
                Swipe Left to go back to previous one

                Let's move on to the next part of the guide by swiping right.
                """
            }
        case .functions(let onboardingFunctionsSection):
            switch onboardingFunctionsSection {
            case .mainRecognizerTutorial:
                return """
                The app consists of three tabs. The first one is the camera tab.
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
                The second one is the chat tab.
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
                Last but not least is the settings tab.
                Here, you can customize many app options to your preferences.
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
                Another big module of application are voice commands.
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
                The last major part of the application is vibrations and voice responses system.
                It is automatically activated when you perform any action.
                Let's take issuing the gesture reminder command as an example.
                To issue a voice command, you perform a gesture, after which there will be an immediate vibration.
                After issuing the command, the device will read aloud the available gestures, which serves as the voice response.
                """
            case .feedbackSecondTutorial:
                return """
                Most actions in the application are signaled by vibration and the corresponding voice response.
                Some of them are triggered automatically - for example, in the obstacle warning module.
                After getting too close to any object, the device will vibrate and issue a relevant message.
                """
            }
        case .ending:
            return """
            This would be all from the tutorial.
            Hope you will find the app very useful during your everyday life.
            
            You can always retake this guide by going to Settings tab and choosing appropriate option or just executing voice command:

            „Display Onboarding”

            Swipe right to go to the app or
            Swipe left to go to previous sections of the guide.
            """
        }
    }

}
