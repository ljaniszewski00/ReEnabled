import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @State private var cameraMode: CameraMode = .objectRecognizer
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if cameraMode == .objectRecognizer {
                ObjectsRecognizerView()
                    .ignoresSafeArea()
                    .environmentObject(tabBarStateManager)
            } else if cameraMode == .distanceMeasurer {
                DistanceMeasureView()
                    .ignoresSafeArea()
            }
        }
        .onLongPressGesture {
            if cameraMode == .objectRecognizer {
                cameraMode = .distanceMeasurer
            } else if cameraMode == .distanceMeasurer {
                cameraMode = .objectRecognizer
            }
        }
    }
}

enum CameraMode {
    case objectRecognizer
    case distanceMeasurer
}

#Preview {
    let tabBarStateManager: TabBarStateManager = TabBarStateManager()
    
    return HomeView()
        .environmentObject(tabBarStateManager)
}

private extension Views {
    struct Constants {
        
    }
}
