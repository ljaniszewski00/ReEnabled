enum CameraMLModelFile {
    case roadLightsRecognizer
    case objectsRecognizer
}

extension CameraMLModelFile {
    
    var fileName: String {
        switch self {
        case .roadLightsRecognizer:
            "AmpelPilot_2812rg"
        case .objectsRecognizer:
            "YOLOV3"
        }
    }
}
