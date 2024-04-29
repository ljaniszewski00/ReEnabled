enum CameraMLModelFile {
    case pedestrianCrossingRecognizer
    case roadLightsRecognizer
    case objectsRecognizer
}

extension CameraMLModelFile {
    
    var fileName: String {
        switch self {
        case .pedestrianCrossingRecognizer:
            "LytNetV1"
        case .roadLightsRecognizer:
            "AmpelPilot_2812rg"
        case .objectsRecognizer:
            "YOLOV3"
        }
    }
}
