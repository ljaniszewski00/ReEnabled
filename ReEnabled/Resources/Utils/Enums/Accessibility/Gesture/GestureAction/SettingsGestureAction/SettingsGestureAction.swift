enum SettingsGestureAction {
    case readSettingName
    case changeSpecificSetting
    case readSettingDescription
}

extension SettingsGestureAction {
    var description: String {
        switch self {
        case .readSettingName:
            "Read setting name"
        case .changeSpecificSetting:
            "Change specific setting"
        case .readSettingDescription:
            "Read setting description"
        }
    }
}
