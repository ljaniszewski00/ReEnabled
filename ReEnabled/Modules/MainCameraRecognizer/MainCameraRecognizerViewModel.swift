import SwiftUI

class MainCameraRecognizerViewModel: ObservableObject {
    @Inject var settingsProvider: SettingsProvider
    
    @Published var defaultCameraMode: CameraMode = .mainRecognizer
    @Published var cameraMode: CameraMode = .mainRecognizer
    @Published var cameraModeNameVisible: Bool = true
    
    init() {
        self.defaultCameraMode = settingsProvider.cameraMode
        self.cameraMode = self.defaultCameraMode
    }
    
    func changeToPreviousCameraMode() {
        guard let newCameraMode = CameraMode.allCases.after(cameraMode) else {
            return
        }
        
        cameraMode = newCameraMode
        onNewCameraModeAppear()
    }
    
    func changeToNextCameraMode() {
        guard let newCameraMode = CameraMode.allCases.after(cameraMode) else {
            return
        }
        
        cameraMode = newCameraMode
        onNewCameraModeAppear()
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
}
