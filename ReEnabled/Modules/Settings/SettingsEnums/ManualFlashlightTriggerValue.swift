enum ManualFlashlightTriggerValue {
    case highestTolerance
    case mediumTolerance
    case lowestTolerance
}

extension ManualFlashlightTriggerValue {
    var rawValue: String {
        switch self {
        case .highestTolerance:
            OtherText.manualFlashlightTriggerValueHighestTolerance.rawValue.localized()
        case .mediumTolerance:
            OtherText.manualFlashlightTriggerValueMediumTolerance.rawValue.localized()
        case .lowestTolerance:
            OtherText.manualFlashlightTriggerValueLowestTolerance.rawValue.localized()
        }
    }
    
    var settingDescription: String? {
        switch self {
        case .highestTolerance:
            OtherText.manualFlashlightTriggerValueHighestToleranceDescription.rawValue.localized()
        case .mediumTolerance:
            ""
        case .lowestTolerance:
            OtherText.manualFlashlightTriggerValueLowestToleranceDescription.rawValue.localized()
        }
    }
    
    var flashlightTriggerValue: Float {
        switch self {
        case .highestTolerance:
            1.45
        case .mediumTolerance:
            15.0
        case .lowestTolerance:
            50.0
        }
    }
    
    static func getFlashlighTriggerLightValueFrom(_ value: Float) -> ManualFlashlightTriggerValue? {
        switch value {
        case 1.45:
            return .highestTolerance
        case 15.0:
            return .mediumTolerance
        case 50.0:
            return .lowestTolerance
        default:
            return nil
        }
    }
}

extension ManualFlashlightTriggerValue: CaseIterable {
    static let allCases: [Self] = [
        .highestTolerance,
        .mediumTolerance,
        .lowestTolerance
    ]
}
