enum MainRecognizerVoiceRequest {
    case readObjects
}

extension MainRecognizerVoiceRequest {
    var rawValue: String {
        switch self {
        case .readObjects:
            VoiceRequestText.mainRecognizerVoiceRequestReadObjects.rawValue.localized()
        }
    }
}

extension MainRecognizerVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .camera(.mainRecognizer(.readObjects))
    ]
}
