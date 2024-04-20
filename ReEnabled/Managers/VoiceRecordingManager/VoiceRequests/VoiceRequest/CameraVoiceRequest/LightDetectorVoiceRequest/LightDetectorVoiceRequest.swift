enum LightDetectorVoiceRequest: String {
    case startLightDetection = "Start light detection"
    case stopLightDetection = "Stop light detection"
}

extension LightDetectorVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .camera(.lightDetector(.startLightDetection)),
        .camera(.lightDetector(.stopLightDetection))
    ]
}
