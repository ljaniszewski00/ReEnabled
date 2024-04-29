import RealmSwift

enum CameraMode: PersistableEnum {
    case mainRecognizer
    case documentScanner
    case colorDetector
    case lightDetector
    
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case OtherText.cameraModeMainRecognizer.rawValue.localized() : self = .mainRecognizer
        case OtherText.cameraModeDocumentScanner.rawValue.localized() : self = .documentScanner
        case OtherText.cameraModeColorDetector.rawValue.localized() : self = .colorDetector
        case OtherText.cameraModeLightDetector.rawValue.localized() : self = .lightDetector
        default: return nil
        }
    }
}

extension CameraMode {
    var rawValue: String {
        switch self {
        case .mainRecognizer:
            return OtherText.cameraModeMainRecognizer.rawValue.localized()
        case .documentScanner:
            return OtherText.cameraModeDocumentScanner.rawValue.localized()
        case .colorDetector:
            return OtherText.cameraModeColorDetector.rawValue.localized()
        case .lightDetector:
            return OtherText.cameraModeLightDetector.rawValue.localized()
        }
    }
}

extension CameraMode {
    static var modesWithPortraitVideoConnection: [CameraMode] {
        [
            .mainRecognizer
        ]
    }
}

extension CameraMode: CaseIterable {
    static var allCases: [CameraMode] {
        [
            .mainRecognizer,
            .documentScanner,
            .colorDetector,
            .lightDetector
        ]
    }
}
