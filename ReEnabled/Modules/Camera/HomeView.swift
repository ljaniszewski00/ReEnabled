import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()
    
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
            
            if homeViewModel.cameraModeNameVisible {
                Text(homeViewModel.cameraMode.rawValue)
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
        .onSwipe(fromRightToLeft: {
            homeViewModel.changeToPreviousCameraMode()
        }, fromLeftToRight: {
            homeViewModel.changeToNextCameraMode()
        })
        .onAppear {
            homeViewModel.onNewCameraModeAppear()
        }
    }
}

#Preview {
    let tabBarStateManager: TabBarStateManager = TabBarStateManager()
    
    return HomeView()
        .environmentObject(tabBarStateManager)
}

private extension Views {
    struct Constants {
        static let topInsetValue: CGFloat = 40
        static let cameraModeNameBackgroundCornerRadius: CGFloat = 10
    }
}
