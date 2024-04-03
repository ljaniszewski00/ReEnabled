import SwiftUI

class MainCameraRecognizerViewModel: ObservableObject {
    @Inject var settingsProvider: SettingsProvider
    
    @Published var defaultCameraMode: CameraMode = .mainRecognizer
    @Published var cameraMode: CameraMode = .mainRecognizer
    @Published var cameraModeNameVisible: Bool = true
    
    private var feedbackManager: FeedbackManager = .shared
    
    init() {
        self.defaultCameraMode = settingsProvider.cameraMode
        self.cameraMode = self.defaultCameraMode
    }
    
    func changeToPreviousCameraMode() {
        let currentIndex = CameraMode.allCases.firstIndex(of: cameraMode) ?? -1
        var previousIndex = currentIndex - 1
        previousIndex = CameraMode.allCases.indices.contains(previousIndex) ?
        previousIndex : CameraMode.allCases.count - 1
        cameraMode = CameraMode.allCases[previousIndex]
        onNewCameraModeAppear()
        feedbackManager.generateSpeechFeedback(with: .camera(.mainRecognizer(.cameraModeHasBeenSetTo)),
                                               and: cameraMode.rawValue)
    }
    
    func changeToNextCameraMode() {
        let currentIndex = CameraMode.allCases.firstIndex(of: cameraMode) ?? -1
        var nextIndex = currentIndex + 1
        nextIndex = CameraMode.allCases.indices.contains(nextIndex) ? nextIndex : 0
        cameraMode = CameraMode.allCases[nextIndex]
        onNewCameraModeAppear()
        feedbackManager.generateSpeechFeedback(with: .camera(.mainRecognizer(.cameraModeHasBeenSetTo)),
                                               and: cameraMode.rawValue)
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
