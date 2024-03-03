enum MLModelFile {
    case ageRecognizer
    case currencyDetector
    case emotionsRecognizer
    case genderRecognizer
    case pedestrianCrossingRecognizer
    case roadLightsRecognizer
    case objectsRecognizer
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
        case .pedestrianCrossingRecognizer:
            "LytNetV1"
        case .roadLightsRecognizer:
            "AmpelPilot_2812rg"
        case .objectsRecognizer:
            "YOLOV3"
        }
    }
}
