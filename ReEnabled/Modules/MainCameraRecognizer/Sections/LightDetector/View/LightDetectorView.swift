import SwiftUI

struct LightDetectorView: View {
    @EnvironmentObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel
    
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    
    @StateObject private var lightDetectorViewModel: LightDetectorViewModel = LightDetectorViewModel()
    
    var body: some View {
        ZStack {
            LightDetectorViewControllerRepresentable(lightDetectorViewModel: lightDetectorViewModel)
                .opacity(lightDetectorViewModel.canDisplayCamera ? 1 : 0)
            
            VStack {
                Spacer()
                
                if let luminosity = lightDetectorViewModel.detectedLuminosity {
                    Text(luminosity)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.bottom, Views.Constants.luminocityToDisplayBottomPadding)
                }
            }
        }
        .onAppear {
            if tabBarStateManager.tabSelection == .camera {
                lightDetectorViewModel.playSound()
            }
        }
        .onDisappear {
            lightDetectorViewModel.stopSound()
        }
        .onChange(of: lightDetectorViewModel.luminosity) { _, newValue in
            lightDetectorViewModel.playSound()
        }
        .onChange(of: tabBarStateManager.tabSelection) { oldTab, newTab in
            if oldTab == .camera && newTab != .camera {
                lightDetectorViewModel.stopSound()
            } 
            
            if newTab == .camera {
                lightDetectorViewModel.playSound()
            }
        }
        .onTwoTouchSwipe(direction: .up, onSwipe: {
            voiceRecordingManager.manageTalking()
        })
        .addGesturesActions(toExecuteBeforeEveryAction: {
        }, toExecuteAfterEveryAction: {
            feedbackManager.generateHapticFeedbackForSwipeAction()
        }, onTap: {
        }, onDoubleTap: {
        }, onTrippleTap: {
            voiceRecordingManager.manageTalking()
        }, onLongPress: {
        }, onSwipeFromLeftToRight: {
            mainCameraRecognizerViewModel.changeToNextCameraMode()
        }, onSwipeFromRightToLeft: {
            mainCameraRecognizerViewModel.changeToPreviousCameraMode()
        }, onSwipeFromUpToDown: {
        }, onSwipeFromDownToUp: {
        }, onSwipeFromLeftToRightAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.chat)
        }, onSwipeFromRightToLeftAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.settings)
        }, onSwipeFromUpToDownAfterLongPress: {
        }, onSwipeFromDownToUpAfterLongPress: {
        })
    }
}

#Preview {
    ColorDetectorView()
}

private extension Views {
    struct Constants {
        static let luminocityToDisplayBottomPadding: CGFloat = 100
    }
}
