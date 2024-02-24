enum MLModelFile {
    case currencyDetector
    case YOLOv3Int8LUT
}

extension MLModelFile {
    
    var fileName: String {
        switch self {
        case .currencyDetector:
            "CurrencyDetector"
        case .YOLOv3Int8LUT:
            "YOLOv3Int8LUT"
        }
    }
}
