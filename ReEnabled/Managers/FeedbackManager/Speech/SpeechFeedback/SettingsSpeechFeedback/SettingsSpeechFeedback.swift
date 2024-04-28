enum SettingsSpeechFeedback {
    case welcomeHint
    case defaultCameraModeHasBeenSetTo
    case defaultMeasureUnitHasBeenSetTo
    case flashlightTriggerModeHasBeenSetTo
    case speechSpeedHasBeenSetTo
    case speechVoiceTypeHasBeenSetTo
    case speechLanguageHasBeenSetTo
    case voiceRecordingLanguageHasBeenSetTo
    case subscriptionPlanHasBeenChangedTo
    case allConversationsDeleted
    case restoredDefaultSettings
}

extension SettingsSpeechFeedback {
    var rawValue: String {
        switch self {
        case .welcomeHint:
            return SpeechFeedbackText.settingsSpeechFeedbackWelcomeHint.rawValue.localized()
        case .defaultCameraModeHasBeenSetTo:
            return SpeechFeedbackText.settingsSpeechFeedbackDefaultCameraModeHasBeenSetTo.rawValue.localized()
        case .defaultMeasureUnitHasBeenSetTo:
            return SpeechFeedbackText.settingsSpeechFeedbackDefaultMeasureUnitHasBeenSetTo.rawValue.localized()
        case .flashlightTriggerModeHasBeenSetTo:
            return SpeechFeedbackText.settingsSpeechFeedbackFlashlightTriggerModeHasBeenSetTo.rawValue.localized()
        case .speechSpeedHasBeenSetTo:
            return SpeechFeedbackText.settingsSpeechFeedbackSpeechSpeedHasBeenSetTo.rawValue.localized()
        case .speechVoiceTypeHasBeenSetTo:
            return SpeechFeedbackText.settingsSpeechFeedbackSpeechVoiceTypeHasBeenSetTo.rawValue.localized()
        case .speechLanguageHasBeenSetTo:
            return SpeechFeedbackText.settingsSpeechFeedbackSpeechLanguageHasBeenSetTo.rawValue.localized()
        case .voiceRecordingLanguageHasBeenSetTo:
            return SpeechFeedbackText.settingsSpeechFeedbackVoiceRecordingLanguageHasBeenSetTo.rawValue.localized()
        case .subscriptionPlanHasBeenChangedTo:
            return SpeechFeedbackText.settingsSpeechFeedbackSubscriptionPlanHasBeenChangedTo.rawValue.localized()
        case .allConversationsDeleted:
            return SpeechFeedbackText.settingsSpeechFeedbackAllConversationsDeleted.rawValue.localized()
        case .restoredDefaultSettings:
            return SpeechFeedbackText.settingsSpeechFeedbackRestoredDefaultSettings.rawValue.localized()
        }
    }
}
