enum DocumentScannerVoiceRequest {
    case readText
    case readBarCodes
}

extension DocumentScannerVoiceRequest {
    var rawValue: String {
        switch self {
        case .readText:
            return VoiceRequestText.documentScannerVoiceRequestReadText.rawValue.localized()
        case .readBarCodes:
            return VoiceRequestText.documentScannerVoiceRequestReadBarCodes.rawValue.localized()
        }
    }
}

extension DocumentScannerVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .camera(.documentScanner(.readText)),
        .camera(.documentScanner(.readBarCodes))
    ]
}

