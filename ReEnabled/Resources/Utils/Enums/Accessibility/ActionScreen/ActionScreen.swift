struct ActionScreen {
    let screenType: ActionScreenType
    
    var gesturesActions: [GestureType: GestureAction] {
        switch screenType {
        case .mainRecognizer:
            [
                .singleTap: .camera(.mainRecognizer(.readRecognizedObjects)),
                .trippleTap: .camera(.mainRecognizer(.speakCameraModeName)),
                .swipeRight: .camera(.mainRecognizer(.changeToNextCameraMode)),
                .swipeLeft: .camera(.mainRecognizer(.changeToPreviousCameraMode))
            ]
        case .documentScanner:
            [
                
            ]
        case .colorDetector:
            [
                
            ]
        case .lightDetector:
            [
                
            ]
        case .chat:
            [
                
            ]
        case .settings:
            [
                
            ]
        case .onboarding:
            [
                
            ]
        }
    }
}
