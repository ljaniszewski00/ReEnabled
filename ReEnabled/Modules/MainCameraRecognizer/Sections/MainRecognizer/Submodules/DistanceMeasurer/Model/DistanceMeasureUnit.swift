import RealmSwift

enum DistanceMeasureUnit: String, PersistableEnum {
    case centimeters = "Centimeters"
    case meters = "Meters"
}

extension DistanceMeasureUnit: CaseIterable {
    static var allCases: [DistanceMeasureUnit] {
        [
            .centimeters,
            .meters
        ]
    }
}
