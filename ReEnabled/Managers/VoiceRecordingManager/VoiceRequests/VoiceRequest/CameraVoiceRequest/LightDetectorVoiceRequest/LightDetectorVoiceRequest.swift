enum LightDetectorVoiceRequest {
    case startLightDetection
    case stopLightDetection
}

extension LightDetectorVoiceRequest {
    var rawValue: String {
        switch self {
        case .startLightDetection:
            return VoiceRequestText.lightDetectorVoiceRequestStartLightDetection.rawValue.localized()
        case .stopLightDetection:
            return VoiceRequestText.lightDetectorVoiceRequestStopLightDetection.rawValue.localized()
        }
    }
}

extension LightDetectorVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .camera(.lightDetector(.startLightDetection)),
        .camera(.lightDetector(.stopLightDetection))
    ]
}
