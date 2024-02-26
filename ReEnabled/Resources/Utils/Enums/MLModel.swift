enum MLModelFile {
    case ageRecognizer
    case currencyDetector
    case emotionsRecognizer
    case genderRecognizer
    case YOLOv3Int8LUT
}

extension MLModelFile {
    
    var fileName: String {
        switch self {
        case .ageRecognizer:
            "AgeNet"
        case .currencyDetector:
            "CurrencyDetector"
        case .emotionsRecognizer:
            "CNNEmotions"
        case .genderRecognizer:
            "GenderNet"
        case .YOLOv3Int8LUT:
            "YOLOv3Int8LUT"
        }
    }
}
