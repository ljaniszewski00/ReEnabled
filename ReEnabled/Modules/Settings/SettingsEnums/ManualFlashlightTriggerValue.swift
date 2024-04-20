enum ManualFlashlightTriggerValue: String {
    case highestTolerance = "Highest Tolerance"
    case mediumTolerance = "Medium Tolerance"
    case lowestTolerance = "Lowest Tolerance"
}

extension ManualFlashlightTriggerValue: CaseIterable {
    static let allCases: [Self] = [
        .highestTolerance,
        .mediumTolerance,
        .lowestTolerance
    ]
}

extension ManualFlashlightTriggerValue {
    var settingDescription: String? {
        switch self {
        case .highestTolerance:
            "Highest tolerance towards darkness"
        case .mediumTolerance:
            ""
        case .lowestTolerance:
            "Lowest tolerance towards darkness"
        }
    }
    
    var flashlightTriggerValue: Float {
        switch self {
        case .highestTolerance:
            1.6
        case .mediumTolerance:
            15.0
        case .lowestTolerance:
            50.0
        }
    }
    
    static func getFlashlighTriggerLightValueFrom(_ value: Float) -> ManualFlashlightTriggerValue? {
        switch value {
        case 1.6:
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
