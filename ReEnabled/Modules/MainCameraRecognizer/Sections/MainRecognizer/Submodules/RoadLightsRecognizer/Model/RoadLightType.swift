enum RoadLightType {
    case red
    case green
    case yellow
    case none
}

extension RoadLightType {
    var rawValue: String {
        switch self {
        case .red:
            MLModelLabelText.roadLightMLModelRed.rawValue.localized().capitalized
        case .green:
            MLModelLabelText.roadLightMLModelGreen.rawValue.localized().capitalized
        case .yellow:
            MLModelLabelText.roadLightMLModelYellow.rawValue.localized().capitalized
        case .none:
            "none"
        }
    }
}

extension RoadLightType: CaseIterable {
    static let allCases: [RoadLightType] = [
        .red,
        .green,
        .yellow,
        .none
    ]
}
