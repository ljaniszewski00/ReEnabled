import SwiftUI

struct MainCameraRecognizerView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel = MainCameraRecognizerViewModel()
    
    private var topInsetValue: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first?.inputView?.window else {
            return Views.Constants.topInsetValue
        }
        
        return window.safeAreaInsets.top
    }
    
    var body: some View {
        ZStack(alignment: .top) {
//            switch homeViewModel.cameraMode {
//            case .mainRecognizer:
//                MainRecognizerView()
//            case .documentScanner:
//                DocumentScannerView()
//            case .colorDetector:
//                ColorDetectorView()
//            case .lightDetector:
//                LightDetectorView()
////            case .currencyDetector:
////                CurrencyDetectorView()
////            case .facialRecognizer:
////                FacialRecognizerView()
//            }
            
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
        .addGesturesActions(onTap: {
            
        }, onDoubleTap: {
            
        }, onLongPress: {
            
        }, onSwipeFromLeftToRight: {
            mainCameraRecognizerViewModel.changeToNextCameraMode()
        }, onSwipeFromRightToLeft: {
            mainCameraRecognizerViewModel.changeToPreviousCameraMode()
        }, onSwipeFromUpToDown: {
            
        }, onSwipeFromDownToUp: {
            
        }, onSwipeFromLeftToRightAfterLongPress: {
            
        }, onSwipeFromRightToLeftAfterLongPress: {
            
        }, onSwipeFromUpToDownAfterLongPress: {
            
        }, onSwipeFromDownToUpAfterLongPress: {
            
        })
        .onAppear {
            mainCameraRecognizerViewModel.onNewCameraModeAppear()
        }
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
