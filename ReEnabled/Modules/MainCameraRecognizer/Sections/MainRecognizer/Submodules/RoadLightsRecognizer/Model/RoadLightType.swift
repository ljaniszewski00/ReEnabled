enum RoadLightType {
    case red
    case green
    case none
}

extension RoadLightType {
    var rawValue: String {
        switch self {
        case .red:
            MLModelLabelText.roadLightMLModelRed.rawValue.localized().capitalized
        case .green:
            MLModelLabelText.roadLightMLModelGreen.rawValue.localized().capitalized
        case .none:
            "none"
        }
    }
}

extension RoadLightType: CaseIterable {
    static let allCases: [RoadLightType] = [
        .red,
        .green,
        .none
    ]
}
