enum SettingsGestureAction {
    case readSettingName
    case changeSpecificSetting
    case readSettingDescription
}

extension SettingsGestureAction {
    var description: String {
        switch self {
        case .readSettingName: GestureActionText.settingsGestureActionReadSettingNameDescription.rawValue.localized()
        case .changeSpecificSetting: GestureActionText.settingsGestureActionChangeSpecificSettingDescription.rawValue.localized()
        case .readSettingDescription: GestureActionText.settingsGestureActionReadSettingDescriptionDescription.rawValue.localized()
        }
    }
}
