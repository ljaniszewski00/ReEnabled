enum SpeechSpeed {
    case fastest
    case faster
    case normal
    case slower
    case slowest
}

extension SpeechSpeed {
    var rawValue: String {
        switch self {
        case .fastest:
            OtherText.speechSpeedFastest.rawValue.localized()
        case .faster:
            OtherText.speechSpeedFaster.rawValue.localized()
        case .normal:
            OtherText.speechSpeedNormal.rawValue.localized()
        case .slower:
            OtherText.speechSpeedSlower.rawValue.localized()
        case .slowest:
            OtherText.speechSpeedSlowest.rawValue.localized()
        }
    }
    
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

extension SpeechSpeed: CaseIterable {
    static let allCases: [Self] = [
        .fastest,
        .faster,
        .normal,
        .slower,
        .slowest
    ]
}
