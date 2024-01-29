import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var cameraMode: CameraMode = .objectRecognizer
    
    func changeToPreviousCameraMode() {
        let currentIndex = CameraMode.allCases.firstIndex(of: cameraMode) ?? -1
        var previousIndex = currentIndex - 1
        previousIndex = CameraMode.allCases.indices.contains(previousIndex) ?
        previousIndex : CameraMode.allCases.count - 1
        cameraMode = CameraMode.allCases[previousIndex]
        generateHaptickFeedback()
    }
    
    func changeToNextCameraMode() {
        let currentIndex = CameraMode.allCases.firstIndex(of: cameraMode) ?? -1
        var nextIndex = currentIndex + 1
        nextIndex = CameraMode.allCases.indices.contains(nextIndex) ? nextIndex : 0
        cameraMode = CameraMode.allCases[nextIndex]
        generateHaptickFeedback()
    }
    
    private func generateHaptickFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
