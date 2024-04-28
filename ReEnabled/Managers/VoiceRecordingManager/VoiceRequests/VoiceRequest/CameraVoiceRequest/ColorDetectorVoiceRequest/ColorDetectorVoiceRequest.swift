enum ColorDetectorVoiceRequest {
    case readColor
}

extension ColorDetectorVoiceRequest {
    var rawValue: String {
        switch self {
        case .readColor:
            return VoiceRequestText.colorDetectorVoiceRequestReadColor.rawValue.localized()
        }
    }
}

extension ColorDetectorVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .camera(.colorDetector(.readColor))
    ]
}
