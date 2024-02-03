enum CameraMode: String {
    case objectRecognizer = "Object Recognizer"
    case distanceMeasurer = "Distance Measurer"
    case documentScanner = "Document Scanner"
    case colorDetector = "Color Detector"
    case lightDetector = "Light Detector"
    case currencyDetector = "Currency Detector"
}

extension CameraMode {
    static var allCases: [CameraMode] {
        [
            .objectRecognizer,
            .distanceMeasurer,
            .documentScanner,
            .colorDetector,
            .lightDetector,
            .currencyDetector
        ]
    }
}
