enum MainRecognizerSpeechFeedback: String {
    case cameraModeHasBeenSetTo = "Camera mode has been set to"
    
    case noObjectsRecognized = "No objects have been recognized"
    case followingObjectsHaveBeenRecognized = "Following objects have been recognized"
    
    case distanceToDominantObjectInCamera = "Distance to dominant object in camera is"
    case distanceWarning = "Be careful. Obstacle is close"
    
    case redLightHasBeenDetected = "Red light has been detected"
    case greenLightHasBeenDetected = "Green light has been detected"
    
    case pedestrianCrossingHasBeenDetectedHereAreTheInstructions = "Pedestrian crossing has been detected. Here Are the instructions"
    case personGoodPosition = "You are in good position to cross the street"
    case personMoveLeft = "Move left"
    case personMoveRight = "Move right"
    case deviceGoodOrientation = "Device is in good orientation to navigate the crossing"
    case deviceTurnLeft = "Turn the device left"
    case deviceTurnRight = "Turn the device right"
}
