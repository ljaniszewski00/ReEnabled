enum MLModelFile {
    case ageRecognizer
    case roadSignsRecognizer
    case currencyDetector
    case emotionsRecognizer
    case genderRecognizer
    case roadLightsRecognizer
    case YOLOv3Int8LUT
}

extension MLModelFile {
    
    var fileName: String {
        switch self {
        case .ageRecognizer:
            "AgeNet"
        case .roadSignsRecognizer:
            "MakeML"
        case .currencyDetector:
            "CurrencyDetector"
        case .emotionsRecognizer:
            "CNNEmotions"
        case .genderRecognizer:
            "GenderNet"
        case .roadLightsRecognizer:
            "AmpelPilot_2812rg"
        case .YOLOv3Int8LUT:
            "YOLOv3Int8LUT"
        }
    }
}
