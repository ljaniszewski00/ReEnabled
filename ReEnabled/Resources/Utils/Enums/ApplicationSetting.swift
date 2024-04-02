enum ApplicationSetting {
    case defaultCameraMode
    case defaultDistanceMeasureUnit
    case documentScannerLanguage
    case flashlightTriggerMode
    case speechSpeed
    case speechVoiceType
    case speechLanguage
    case voiceRecordingLanguage
    case subscriptionPlan
    case others
}

extension ApplicationSetting {
    var settingName: String {
        switch self {
        case .defaultCameraMode:
            return "Default Camera Mode"
        case .defaultDistanceMeasureUnit:
            return "Default Distance Measure Unit"
        case .documentScannerLanguage:
            return "Document Scanner Language"
        case .flashlightTriggerMode:
            return "Flashlight Trigger Mode"
        case .speechSpeed:
            return "Speech Speed"
        case .speechVoiceType:
            return "Speech Voice Type"
        case .speechLanguage:
            return "Speech Language"
        case .voiceRecordingLanguage:
            return "Voice Recording Language"
        case .subscriptionPlan:
            return "Subscription Plan"
        case .others:
            return "Others"
        }
    }
    
    var settingDescription: String {
        switch self {
        case .defaultCameraMode:
            return "Set default camera mode that shows after Camera Tab select"
        case .defaultDistanceMeasureUnit:
            return "Choose unit for which distance can be measured to avoid obstacles"
        case .documentScannerLanguage:
            return "Choose language in which documents you scan are written"
        case .flashlightTriggerMode:
            return "Select value for which the flashlight will be triggered. When set to automatic, device will decide for itself, whereas all other values represent tolerance towards darkness - the higher tolerance, the more dark is needed to turn the flashlight on"
        case .speechSpeed:
            return "Select speed that should be applied for speech feedback"
        case .speechVoiceType:
            return "Choose voice type the device should use for speech feedback"
        case .speechLanguage:
            return "Choose language the device should use for speech feedback"
        case .voiceRecordingLanguage:
            return "Choose language you will speak while giving voice commands"
        case .subscriptionPlan:
            return "Select subscription plan that suits your needs the most"
        case .others:
            return "Execute some other actions"
        }
    }
}
