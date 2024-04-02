enum SettingsVoiceRequest: String {
    case changeDefaultCameraModeToMainRecognizer = "Change default camera mode to main recognizer"
    case changeDefaultCameraModeToDocumentScanner = "Change default camera mode to document scanner"
    case changeDefaultCameraModeToColorDetector = "Change default camera mode to color detector"
    case changeDefaultCameraModeToLightDetector = "Change default camera mode to light detector"
    
    case changeDefaultDistanceMeasureUnitToCentimeters = "Change default measure unit to centimeters"
    case changeDefaultDistanceMeasureUnitToMeters = "Change default measure unit to meters"
    
    case changeScannerLanguageToEnglish = "Change scanner language to english"
    case changeScannerLanguageToPolish = "Change scanner language to polish"
    
    case changeFlashlightTriggerModeToAutomatic = "Change flashlight trigger mode to automatic"
    case changeFlashlightTriggerModeToManualWithHighTolerance = "Change flashlight trigger mode to manual with high tolerance"
    case changeFlashlightTriggerModeToManualWithMediumTolerance = "Change flashlight trigger mode to manual with medium tolerance"
    case changeFlashlightTriggerModeToManualWithLowTolerance = "Change flashlight trigger mode to manual with low tolerance"
    
    case changeSpeechSpeedToFastest = "Change speech speed to fastest"
    case changeSpeechSpeedToFaster = "Change speech speed to faster"
    case changeSpeechSpeedToNormal = "Change speech speed to normal"
    case changeSpeechSpeedToSlower = "Change speech speed to slower"
    case changeSpeechSpeedToSlowest = "Change speech speed to slowest"
    
    case changeSpeechVoiceTypeToFemale = "Change speech voice type to female"
    case changeSpeechVoiceTypeToMale = "Change speech voice type to male"
    
    case changeSpeechLanguageToEnglish = "Change speech language to english"
    case changeSpeechLanguageToPolish = "Change speech language to polish"
    
    case changeVoiceRecordingLanguageToEnglish = "Change voice recording language to english"
    case changeVoiceRecordingLanguageToPolish = "Change voice recording language to polish"
    
    case deleteAllConversations = "Delete all conversations"
    case restoreDefaultSettings = "Restore default settings"
}
