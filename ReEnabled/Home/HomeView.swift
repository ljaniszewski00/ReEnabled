import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        Group {
            if homeViewModel.cameraMode == .objectRecognizer {
                ObjectsRecognizerView()
                    .ignoresSafeArea()
                    .environmentObject(tabBarStateManager)
            } else if homeViewModel.cameraMode == .distanceMeasurer {
                DistanceMeasureView()
                    .ignoresSafeArea()
            }
        }
        .onLongPressGesture {
            homeViewModel.handleCameraModeChange()
        }
    }
}

#Preview {
    let tabBarStateManager: TabBarStateManager = TabBarStateManager()
    
    return HomeView()
        .environmentObject(tabBarStateManager)
}
