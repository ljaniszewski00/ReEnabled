enum ColorDetectorVoiceRequest: String {
    case readColor = "Read color"
}

extension ColorDetectorVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .camera(.colorDetector(.readColor))
    ]
}
