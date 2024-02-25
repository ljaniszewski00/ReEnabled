import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var cameraMode: CameraMode = .distanceMeasurer
    @Published var cameraModeNameVisible: Bool = true
    
    func changeToPreviousCameraMode() {
        let currentIndex = CameraMode.allCases.firstIndex(of: cameraMode) ?? -1
        var previousIndex = currentIndex - 1
        previousIndex = CameraMode.allCases.indices.contains(previousIndex) ?
        previousIndex : CameraMode.allCases.count - 1
        cameraMode = CameraMode.allCases[previousIndex]
        onNewCameraModeAppear()
        generateHaptickFeedback()
    }
    
    func changeToNextCameraMode() {
        let currentIndex = CameraMode.allCases.firstIndex(of: cameraMode) ?? -1
        var nextIndex = currentIndex + 1
        nextIndex = CameraMode.allCases.indices.contains(nextIndex) ? nextIndex : 0
        cameraMode = CameraMode.allCases[nextIndex]
        onNewCameraModeAppear()
        generateHaptickFeedback()
    }
    
    func onNewCameraModeAppear() {
        showCameraModeName()
        hideCameraModeNameAfterDelay()
    }
    
    private func showCameraModeName() {
        withAnimation {
            cameraModeNameVisible = true
        }
    }
    
    private func hideCameraModeNameAfterDelay() {
        let timeToHideCameraModeNameLabel: DispatchTime = .now() + 5
        DispatchQueue.main.asyncAfter(deadline: timeToHideCameraModeNameLabel) {
            withAnimation {
                self.cameraModeNameVisible = false
            }
        }
    }
    
    private func generateHaptickFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
