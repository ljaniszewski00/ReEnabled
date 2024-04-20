enum DocumentScannerVoiceRequest: String {
    case readText = "Read text"
    case readBarCodes = "Read bar codes"
}

extension DocumentScannerVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .camera(.documentScanner(.readText)),
        .camera(.documentScanner(.readBarCodes))
    ]
}

