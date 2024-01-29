enum CameraMode {
    case objectRecognizer
    case distanceMeasurer
    case textReader
    case colorDetector
    case lightDetector
    case barcodeIdentifier
}

extension CameraMode {
    static var allCases: [CameraMode] {
        [
            .objectRecognizer,
            .distanceMeasurer,
            .textReader,
            .colorDetector,
            .lightDetector,
            .barcodeIdentifier
        ]
    }
}
