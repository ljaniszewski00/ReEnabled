enum MainRecognizerSpeechFeedback {
    case welcomeHint
    case cameraModeHasBeenSetTo
    case noObjectsRecognized
    case followingObjectsHaveBeenRecognized
    case distanceToDominantObjectInCamera
    case distanceWarning
    case redLightHasBeenDetected
    case greenLightHasBeenDetected
    case pedestrianCrossingHasBeenDetectedHereAreTheInstructions
    case personGoodPosition
    case personMoveLeft
    case personMoveRight
    case deviceGoodOrientation
    case deviceTurnLeft
    case deviceTurnRight
}

extension MainRecognizerSpeechFeedback {
    var rawValue: String {
        switch self {
        case .welcomeHint:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackWelcomeHint.rawValue.localized()
        case .cameraModeHasBeenSetTo:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackCameraModeHasBeenSetTo.rawValue.localized()
        case .noObjectsRecognized:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackNoObjectsRecognized.rawValue.localized()
        case .followingObjectsHaveBeenRecognized:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackFollowingObjectsHaveBeenRecognized.rawValue.localized()
        case .distanceToDominantObjectInCamera:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackDistanceToDominantObjectInCamera.rawValue.localized()
        case .distanceWarning:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackDistanceWarning.rawValue.localized()
        case .redLightHasBeenDetected:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackRedLightHasBeenDetected.rawValue.localized()
        case .greenLightHasBeenDetected:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackGreenLightHasBeenDetected.rawValue.localized()
        case .pedestrianCrossingHasBeenDetectedHereAreTheInstructions:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackPedestrianCrossingHasBeenDetectedHereAreTheInstructions.rawValue.localized()
        case .personGoodPosition:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackPersonGoodPosition.rawValue.localized()
        case .personMoveLeft:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackPersonMoveLeft.rawValue.localized()
        case .personMoveRight:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackPersonMoveRight.rawValue.localized()
        case .deviceGoodOrientation:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackDeviceGoodOrientation.rawValue.localized()
        case .deviceTurnLeft:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackDeviceTurnLeft.rawValue.localized()
        case .deviceTurnRight:
            return SpeechFeedbackText.mainRecognizerSpeechFeedbackDeviceTurnRight.rawValue.localized()
        }
    }
}
