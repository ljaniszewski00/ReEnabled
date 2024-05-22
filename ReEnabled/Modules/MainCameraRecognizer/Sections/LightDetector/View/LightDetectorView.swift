import SwiftUI

struct LightDetectorView: View {
    @EnvironmentObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel
    
    @StateObject private var lightDetectorViewModel: LightDetectorViewModel = LightDetectorViewModel()
    
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var voiceRequestor: VoiceRequestor = .shared
    
    var body: some View {
        ZStack {
            LightDetectorViewControllerRepresentable(lightDetectorViewModel: lightDetectorViewModel)
            
            VStack {
                Spacer()
                
                if let luminosity = lightDetectorViewModel.detectedLuminosity {
                    Text(luminosity)
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.vertical, Views.Constants.luminosityLabelVerticalPadding)
                        .padding(.horizontal)
                        .background (
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: Views.Constants.luminosityLabelBackgroundCornerRadius,
                                                 style: .continuous)
                        )
                        .padding(.bottom, Views.Constants.luminosityToDisplayBottomPadding)
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
            if tabBarStateManager.tabSelection == .camera && mainCameraRecognizerViewModel.cameraMode == .lightDetector {
                lightDetectorViewModel.playSound()
            }
        }
        .onChange(of: tabBarStateManager.tabSelection) { oldTab, newTab in
            if oldTab == .camera && newTab != .camera {
                lightDetectorViewModel.stopSound()
            }
            
            if newTab == .camera {
                lightDetectorViewModel.playSound()
            }
        }
        .onChange(of: voiceRequestor.selectedVoiceRequest) { _, voiceRequest in
            guard voiceRequest != VoiceRequest.empty else {
                return
            }
            
            switch voiceRequest {
            case .camera(.lightDetector(.startLightDetection)):
                lightDetectorViewModel.playSound()
            case .camera(.lightDetector(.stopLightDetection)):
                lightDetectorViewModel.stopSound()
            case .other(.remindVoiceCommands):
                guard tabBarStateManager.tabSelection == .camera && mainCameraRecognizerViewModel.cameraMode == .lightDetector else {
                    voiceRequestor.selectedVoiceRequest = .empty
                    return
                }
                
                let actionScreen = ActionScreen(screenType: .lightDetector)
                feedbackManager.generateVoiceRequestsReminder(for: actionScreen)
            case .other(.remindGestures):
                guard tabBarStateManager.tabSelection == .camera && mainCameraRecognizerViewModel.cameraMode == .lightDetector else {
                    voiceRequestor.selectedVoiceRequest = .empty
                    return
                }
                let actionScreen = ActionScreen(screenType: .lightDetector)
                feedbackManager.generateGesturesReminder(for: actionScreen)
            default:
                voiceRequestor.selectedVoiceRequest = .empty
                return
            }
            
            voiceRequestor.selectedVoiceRequest = .empty
        }
        .addGesturesActions(toExecuteBeforeEveryAction: {
        }, toExecuteAfterEveryAction: {
            feedbackManager.generateHapticFeedbackForSwipeAction()
        }, onTap: {
        }, onDoubleTap: {
        }, onTrippleTap: {
            mainCameraRecognizerViewModel.speakCameraModeName()
        }, onLongPress: {
            voiceRecordingManager.manageTalking()
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
        static let luminosityLabelVerticalPadding: CGFloat = 15
        static let luminosityLabelBackgroundCornerRadius: CGFloat = 10
        static let luminosityToDisplayBottomPadding: CGFloat = 100
    }
}
