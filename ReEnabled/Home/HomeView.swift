import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()
    
    private var topInsetValue: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first?.inputView?.window else {
            return 40
        }
        
        return window.safeAreaInsets.top
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            switch homeViewModel.cameraMode {
            case .objectRecognizer:
                ObjectsRecognizerView()
                    .environmentObject(tabBarStateManager)
                    .onAppear {
                        homeViewModel.onNewCameraModeAppear()
                    }
            case .distanceMeasurer:
                DistanceMeasureView()
                    .onAppear {
                        homeViewModel.onNewCameraModeAppear()
                    }
            case .documentScanner:
                DocumentScannerView()
                    .onAppear {
                        homeViewModel.onNewCameraModeAppear()
                    }
            case .colorDetector:
                VStack {
                    Spacer()
                    Text("Color Detector")
                    Spacer()
                }
                .onAppear {
                    homeViewModel.onNewCameraModeAppear()
                }
            case .lightDetector:
                VStack {
                    Spacer()
                    Text("Light Detector")
                    Spacer()
                }
                .onAppear {
                    homeViewModel.onNewCameraModeAppear()
                }
            }
            
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
    }
}

#Preview {
    let tabBarStateManager: TabBarStateManager = TabBarStateManager()
    
    return HomeView()
        .environmentObject(tabBarStateManager)
}

private extension Views {
    struct Constants {
        static let cameraModeNameBackgroundCornerRadius: CGFloat = 10
    }
}
