import RealmSwift

enum CameraMode: String, PersistableEnum {
    case mainRecognizer = "Main Recognizer"
    case documentScanner = "Document Scanner"
    case colorDetector = "Color Detector"
    case lightDetector = "Light Detector"
//    case currencyDetector = "Currency Detector"
//    case facialRecognizer = "Facial Recognizer"
}

extension CameraMode: CaseIterable {
    static var allCases: [CameraMode] {
        [
            .mainRecognizer,
            .documentScanner,
            .colorDetector,
            .lightDetector,
//            .currencyDetector,
//            .facialRecognizer
        ]
    }
}

extension CameraMode {
    static var modesWithPortraitVideoConnection: [CameraMode] {
        [
            .mainRecognizer,
//            .facialRecognizer,
        ]
    }
}
