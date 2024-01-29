import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        Group {
            switch homeViewModel.cameraMode {
            case .objectRecognizer:
                ObjectsRecognizerView()
                    .environmentObject(tabBarStateManager)
            case .distanceMeasurer:
                DistanceMeasureView()
            case .textReader:
                VStack {
                    Spacer()
                    Text("Text Reader")
                    Spacer()
                }
            case .colorDetector:
                VStack {
                    Spacer()
                    Text("Color Detector")
                    Spacer()
                }
            case .lightDetector:
                VStack {
                    Spacer()
                    Text("Light Detector")
                    Spacer()
                }
            case .barcodeIdentifier:
                VStack {
                    Spacer()
                    Text("Barcode Identifier")
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
        .onSwipe(fromRightToLeft: {
            homeViewModel.changeToPreviousCameraMode()
        }, fromLeftToRight: {
            homeViewModel.changeToNextCameraMode()
        })
        .onChange(of: homeViewModel.cameraMode) { newValue in
        print(newValue)}
    }
}

#Preview {
    let tabBarStateManager: TabBarStateManager = TabBarStateManager()
    
    return HomeView()
        .environmentObject(tabBarStateManager)
}
