enum MainRecognizerVoiceRequest: String {
    case readObjects = "Read objects"
}

extension MainRecognizerVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .camera(.mainRecognizer(.readObjects))
    ]
}
