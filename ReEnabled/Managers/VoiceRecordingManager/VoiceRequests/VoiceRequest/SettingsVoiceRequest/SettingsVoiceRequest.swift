enum SettingsVoiceRequest {
    case changeDefaultCameraModeToMainRecognizer
    case changeDefaultCameraModeToDocumentScanner
    case changeDefaultCameraModeToColorDetector
    case changeDefaultCameraModeToLightDetector
    case changeDefaultDistanceMeasureUnitToCentimeters
    case changeDefaultDistanceMeasureUnitToMeters
    case changeFlashlightTriggerModeToAutomatic
    case changeFlashlightTriggerModeToManualWithHighTolerance
    case changeFlashlightTriggerModeToManualWithMediumTolerance
    case changeFlashlightTriggerModeToManualWithLowTolerance
    case changeSpeechSpeedToFastest
    case changeSpeechSpeedToFaster
    case changeSpeechSpeedToNormal
    case changeSpeechSpeedToSlower
    case changeSpeechSpeedToSlowest
    case changeSpeechVoiceTypeToFemale
    case changeSpeechVoiceTypeToMale
    case changeSpeechLanguageToEnglish
    case changeSpeechLanguageToPolish
    case changeVoiceRecordingLanguageToEnglish
    case changeVoiceRecordingLanguageToPolish
    case deleteAllConversations
    case restoreDefaultSettings
}

extension SettingsVoiceRequest {
    var rawValue: String {
        switch self {
        case .changeDefaultCameraModeToMainRecognizer:
            return VoiceRequestText.settingsVoiceRequestChangeDefaultCameraModeToMainRecognizer.rawValue.localized()
        case .changeDefaultCameraModeToDocumentScanner:
            return VoiceRequestText.settingsVoiceRequestChangeDefaultCameraModeToDocumentScanner.rawValue.localized()
        case .changeDefaultCameraModeToColorDetector:
            return VoiceRequestText.settingsVoiceRequestChangeDefaultCameraModeToColorDetector.rawValue.localized()
        case .changeDefaultCameraModeToLightDetector:
            return VoiceRequestText.settingsVoiceRequestChangeDefaultCameraModeToLightDetector.rawValue.localized()
        case .changeDefaultDistanceMeasureUnitToCentimeters:
            return VoiceRequestText.settingsVoiceRequestChangeDefaultDistanceMeasureUnitToCentimeters.rawValue.localized()
        case .changeDefaultDistanceMeasureUnitToMeters:
            return VoiceRequestText.settingsVoiceRequestChangeDefaultDistanceMeasureUnitToMeters.rawValue.localized()
        case .changeFlashlightTriggerModeToAutomatic:
            return VoiceRequestText.settingsVoiceRequestChangeFlashlightTriggerModeToAutomatic.rawValue.localized()
        case .changeFlashlightTriggerModeToManualWithHighTolerance:
            return VoiceRequestText.settingsVoiceRequestChangeFlashlightTriggerModeToManualWithHighTolerance.rawValue.localized()
        case .changeFlashlightTriggerModeToManualWithMediumTolerance:
            return VoiceRequestText.settingsVoiceRequestChangeFlashlightTriggerModeToManualWithMediumTolerance.rawValue.localized()
        case .changeFlashlightTriggerModeToManualWithLowTolerance:
            return VoiceRequestText.settingsVoiceRequestChangeFlashlightTriggerModeToManualWithLowTolerance.rawValue.localized()
        case .changeSpeechSpeedToFastest:
            return VoiceRequestText.settingsVoiceRequestChangeSpeechSpeedToFastest.rawValue.localized()
        case .changeSpeechSpeedToFaster:
            return VoiceRequestText.settingsVoiceRequestChangeSpeechSpeedToFaster.rawValue.localized()
        case .changeSpeechSpeedToNormal:
            return VoiceRequestText.settingsVoiceRequestChangeSpeechSpeedToNormal.rawValue.localized()
        case .changeSpeechSpeedToSlower:
            return VoiceRequestText.settingsVoiceRequestChangeSpeechSpeedToSlower.rawValue.localized()
        case .changeSpeechSpeedToSlowest:
            return VoiceRequestText.settingsVoiceRequestChangeSpeechSpeedToSlowest.rawValue.localized()
        case .changeSpeechVoiceTypeToFemale:
            return VoiceRequestText.settingsVoiceRequestChangeSpeechVoiceTypeToFemale.rawValue.localized()
        case .changeSpeechVoiceTypeToMale:
            return VoiceRequestText.settingsVoiceRequestChangeSpeechVoiceTypeToMale.rawValue.localized()
        case .changeSpeechLanguageToEnglish:
            return VoiceRequestText.settingsVoiceRequestChangeSpeechLanguageToEnglish.rawValue.localized()
        case .changeSpeechLanguageToPolish:
            return VoiceRequestText.settingsVoiceRequestChangeSpeechLanguageToPolish.rawValue.localized()
        case .changeVoiceRecordingLanguageToEnglish:
            return VoiceRequestText.settingsVoiceRequestChangeVoiceRecordingLanguageToEnglish.rawValue.localized()
        case .changeVoiceRecordingLanguageToPolish:
            return VoiceRequestText.settingsVoiceRequestChangeVoiceRecordingLanguageToPolish.rawValue.localized()
        case .deleteAllConversations:
            return VoiceRequestText.settingsVoiceRequestDeleteAllConversations.rawValue.localized()
        case .restoreDefaultSettings:
            return VoiceRequestText.settingsVoiceRequestRestoreDefaultSettings.rawValue.localized()
        }
    }
}

extension SettingsVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .settings(.changeDefaultCameraModeToMainRecognizer),
        .settings(.changeDefaultCameraModeToDocumentScanner),
        .settings(.changeDefaultCameraModeToColorDetector),
        .settings(.changeDefaultCameraModeToLightDetector),
        .settings(.changeDefaultDistanceMeasureUnitToCentimeters),
        .settings(.changeDefaultDistanceMeasureUnitToMeters),
        .settings(.changeFlashlightTriggerModeToAutomatic),
        .settings(.changeFlashlightTriggerModeToManualWithHighTolerance),
        .settings(.changeFlashlightTriggerModeToManualWithMediumTolerance),
        .settings(.changeFlashlightTriggerModeToManualWithLowTolerance),
        .settings(.changeSpeechSpeedToFastest),
        .settings(.changeSpeechSpeedToFaster),
        .settings(.changeSpeechSpeedToNormal),
        .settings(.changeSpeechSpeedToSlower),
        .settings(.changeSpeechSpeedToSlowest),
        .settings(.changeSpeechLanguageToEnglish),
        .settings(.changeSpeechLanguageToPolish),
        .settings(.changeVoiceRecordingLanguageToEnglish),
        .settings(.changeVoiceRecordingLanguageToPolish),
        .settings(.deleteAllConversations),
        .settings(.restoreDefaultSettings)
    ]
}
