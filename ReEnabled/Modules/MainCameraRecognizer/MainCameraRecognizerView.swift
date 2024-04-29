import SwiftUI

struct MainCameraRecognizerView: View {
    @StateObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel = MainCameraRecognizerViewModel()
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    
    @StateObject private var feedbackManager: FeedbackManager = .shared
    
    private var topInsetValue: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first?.inputView?.window else {
            return Views.Constants.topInsetValue
        }
        
        return window.safeAreaInsets.top
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            switch mainCameraRecognizerViewModel.cameraMode {
            case .mainRecognizer:
                MainRecognizerView()
            case .documentScanner:
                DocumentScannerView()
            case .colorDetector:
                ColorDetectorView()
            case .lightDetector:
                LightDetectorView()
            }
            
            if mainCameraRecognizerViewModel.cameraModeNameVisible {
                Text(mainCameraRecognizerViewModel.cameraMode.rawValue)
                    .padding()
                    .padding(.top, topInsetValue)
                    .frame(width: UIScreen.main.bounds.width)
                    .background (
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius:
                                                Views.Constants.cameraModeNameBackgroundCornerRadius,
                                             style: .continuous)
                    )
                    .transition(.move(edge: .top))
                    .animation(.default)
                    .zIndex(1)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            if tabBarStateManager.tabSelection == .camera {
                feedbackManager.generateSpeechFeedback(with: .other(.currentTab),
                                                       and: "\(TabBarItem.camera.title) \(mainCameraRecognizerViewModel.cameraMode.rawValue)")
            }
            
            mainCameraRecognizerViewModel.onNewCameraModeAppear()
        }
        .onChange(of: tabBarStateManager.tabSelection) { _, newTab in
            if newTab == .camera {
                feedbackManager.generateSpeechFeedback(with: "\(TabBarItem.camera.title) \(mainCameraRecognizerViewModel.cameraMode.rawValue)")
            }
        }
        .onChange(of: mainCameraRecognizerViewModel.settingsProvider.cameraMode) { _, newDefaultCameraMode in
            mainCameraRecognizerViewModel.defaultCameraMode = newDefaultCameraMode
        }
        .environmentObject(mainCameraRecognizerViewModel)
    }
}

#Preview {
    MainCameraRecognizerView()
}

private extension Views {
    struct Constants {
        static let topInsetValue: CGFloat = 40
        static let cameraModeNameBackgroundCornerRadius: CGFloat = 10
    }
}
