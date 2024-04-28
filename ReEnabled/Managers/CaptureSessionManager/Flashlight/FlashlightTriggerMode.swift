enum FlashlightTriggerMode {
    case automatic
    case specificLightValue(ManualFlashlightTriggerValue)
}

extension FlashlightTriggerMode {
    var rawValue: String {
        switch self {
        case .automatic:
            return OtherText.flashlightTriggerModeAutomatic.rawValue.localized()
        case .specificLightValue(_):
            return OtherText.flashlightTriggerModeSpecificValue.rawValue.localized()
        }
    }
}
