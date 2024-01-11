import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @StateObject private var cameraViewModel: CameraViewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                CameraView(size: geometry.size)
            }
        }
        .environmentObject(tabBarStateManager)
        .environmentObject(cameraViewModel)
        .onAppear {
            cameraViewModel.onAppear()
        }
    }
}

#Preview {
    let tabBarStateManager: TabBarStateManager = TabBarStateManager()
    
    return HomeView()
        .environmentObject(tabBarStateManager)
}
