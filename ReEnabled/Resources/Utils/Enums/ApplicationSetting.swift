enum ApplicationSetting {
    case defaultCameraMode
    case defaultDistanceMeasureUnit
    case documentScannerLanguage
    case flashlightTriggerMode
    case speechSpeed
    case speechVoiceType
    case subscriptionPlan
    case others
}

extension ApplicationSetting {
    var settingName: String {
        switch self {
        case .defaultCameraMode:
            return OtherText.applicationSettingDefaultCameraMode.rawValue.localized()
        case .defaultDistanceMeasureUnit:
            return OtherText.applicationSettingDefaultDistanceMeasureUnit.rawValue.localized()
        case .documentScannerLanguage:
            return OtherText.applicationSettingDocumentScannerLanguage.rawValue.localized()
        case .flashlightTriggerMode:
            return OtherText.applicationSettingFlashlightTriggerMode.rawValue.localized()
        case .speechSpeed:
            return OtherText.applicationSettingSpeechSpeed.rawValue.localized()
        case .speechVoiceType:
            return OtherText.applicationSettingSpeechVoiceType.rawValue.localized()
        case .subscriptionPlan:
            return OtherText.applicationSettingSubscriptionPlan.rawValue.localized()
        case .others:
            return OtherText.applicationSettingOthers.rawValue.localized()
        }
    }
    
    var settingDescription: String {
        switch self {
        case .defaultCameraMode:
            return OtherText.applicationSettingDefaultCameraModeDescription.rawValue.localized()
        case .defaultDistanceMeasureUnit:
            return OtherText.applicationSettingDefaultDistanceMeasureUnitDescription.rawValue.localized()
        case .documentScannerLanguage:
            return OtherText.applicationSettingDocumentScannerLanguageDescription.rawValue.localized()
        case .flashlightTriggerMode:
            return OtherText.applicationSettingFlashlightTriggerModeDescription.rawValue.localized()
        case .speechSpeed:
            return OtherText.applicationSettingSpeechSpeedDescription.rawValue.localized()
        case .speechVoiceType:
            return OtherText.applicationSettingSpeechVoiceTypeDescription.rawValue.localized()
        case .subscriptionPlan:
            return OtherText.applicationSettingSubscriptionPlanDescription.rawValue.localized()
        case .others:
            return OtherText.applicationSettingOthersDescription.rawValue.localized()
        }
    }
}
