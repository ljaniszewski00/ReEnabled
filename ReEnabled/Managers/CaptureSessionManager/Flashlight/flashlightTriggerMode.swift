enum FlashlightTriggerMode {
    case automatic
    case specificLightValue(Float)
}

extension FlashlightTriggerMode {
    var rawValue: String {
        switch self {
        case .automatic:
            return "Automatic"
        case .specificLightValue(_):
            return "Specific Value"
        }
    }
}
