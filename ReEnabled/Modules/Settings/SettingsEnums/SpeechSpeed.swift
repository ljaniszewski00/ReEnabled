enum SpeechSpeed: String {
    case fastest = "Fastest"
    case faster = "Faster"
    case normal = "Normal"
    case slower = "Slower"
    case slowest = "Slowest"
}

extension SpeechSpeed: CaseIterable {
    static let allCases: [Self] = [
        .fastest,
        .faster,
        .normal,
        .slower,
        .slowest
    ]
}

extension SpeechSpeed {
    var speed: Float {
        switch self {
        case .fastest:
            0.7
        case .faster:
            0.6
        case .normal:
            0.5
        case .slower:
            0.4
        case .slowest:
            0.3
        }
    }
}
