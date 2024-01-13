import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @StateObject private var cameraViewModel: CameraViewModel = CameraViewModel()
    @StateObject private var recognizerViewModel: RecognizerViewModel = RecognizerViewModel()
    
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
        .onChange(of: cameraViewModel.bufferSize) { newSize in
            print()
            print("New Size")
            print(newSize)
            print("--------------")
            print()
            recognizerViewModel.bufferSize = newSize
        }
        .onChange(of: cameraViewModel.isCaptureSessionCommited) { isCommited in
            print()
            print("Is Capture Session Commited")
            print(isCommited)
            print("--------------")
            print()
            if isCommited {
                recognizerViewModel.captureSession = cameraViewModel.captureSession
            }
        }
        .onChange(of: cameraViewModel.rootLayer) { newRootLayer in
            print()
            print("New Root Layer")
            print(newRootLayer)
            print("--------------")
            print()
            recognizerViewModel.rootLayer = newRootLayer
            recognizerViewModel.setupAVCapture()
        }
        .onChange(of: recognizerViewModel.rootLayer) { newRootLayer in
            cameraViewModel.rootLayer = newRootLayer
        }
    }
}

#Preview {
    let tabBarStateManager: TabBarStateManager = TabBarStateManager()
    
    return HomeView()
        .environmentObject(tabBarStateManager)
}
