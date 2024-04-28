import RealmSwift

enum DistanceMeasureUnit: PersistableEnum {
    case centimeters
    case meters
    
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case OtherText.distanceMeasureUnitCentimeters.rawValue.localized() : self = .centimeters
        case OtherText.distanceMeasureUnitMeters.rawValue.localized() : self = .meters
        default: return nil
        }
    }
}

extension DistanceMeasureUnit {
    var rawValue: String {
        switch self {
        case .centimeters:
            OtherText.distanceMeasureUnitCentimeters.rawValue.localized()
        case .meters:
            OtherText.distanceMeasureUnitMeters.rawValue.localized()
        }
    }
}

extension DistanceMeasureUnit: CaseIterable {
    static let allCases: [DistanceMeasureUnit] = [
        .centimeters,
        .meters
    ]
}
