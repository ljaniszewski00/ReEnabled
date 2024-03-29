enum DistanceMeasureUnit: String {
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
