import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var cameraMode: CameraMode = .objectRecognizer
    
    func handleCameraModeChange() {
        let generator = UINotificationFeedbackGenerator()
        
        if cameraMode == .objectRecognizer {
            cameraMode = .distanceMeasurer
        } else if cameraMode == .distanceMeasurer {
            cameraMode = .objectRecognizer
        }
        
        generator.notificationOccurred(.success)
    }
}
