import SwiftUI

struct MainCameraRecognizerView: View {
    @StateObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel = MainCameraRecognizerViewModel()
    
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
//            case .currencyDetector:
//                CurrencyDetectorView()
//            case .facialRecognizer:
//                FacialRecognizerView()
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
            mainCameraRecognizerViewModel.onNewCameraModeAppear()
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
