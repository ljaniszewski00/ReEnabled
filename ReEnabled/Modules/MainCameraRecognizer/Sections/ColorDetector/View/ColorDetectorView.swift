import SwiftUI

struct ColorDetectorView: View {
    @EnvironmentObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel
    
    @StateObject private var colorDetectorViewModel: ColorDetectorViewModel = ColorDetectorViewModel()
    
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var voiceRequestor: VoiceRequestor = .shared
    
    var body: some View {
        ZStack {
            ColorDetectorViewControllerRepresentable(colorDetectorViewModel: colorDetectorViewModel)
            
            VStack {
                Spacer()
                
                if let colorName = colorDetectorViewModel.detectedColorName {
                    Text(colorName)
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.vertical, Views.Constants.colorLabelVerticalPadding)
                        .padding(.horizontal)
                        .background (
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: Views.Constants.colorLabelBackgroundCornerRadius,
                                                 style: .continuous)
                        )
                        .padding(.bottom, Views.Constants.colorToDisplayBottomPadding)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                feedbackManager.generateSpeechFeedback(with: .camera(.colorDetector(.welcomeHint)))
            }
        }
        .onChange(of: voiceRequestor.selectedVoiceRequest) { _, voiceRequest in
            guard voiceRequest != VoiceRequest.empty else {
                return
            }
            
            switch voiceRequest {
            case .camera(.colorDetector(.readColor)):
                colorDetectorViewModel.readDetectedColor()
            case .other(.remindVoiceCommands):
                guard tabBarStateManager.tabSelection == .camera && mainCameraRecognizerViewModel.cameraMode == .colorDetector else {
                    voiceRequestor.selectedVoiceRequest = .empty
                    return
                }
                
                let actionScreen = ActionScreen(screenType: .colorDetector)
                feedbackManager.generateVoiceRequestsReminder(for: actionScreen)
            case .other(.remindGestures):
                guard tabBarStateManager.tabSelection == .camera && mainCameraRecognizerViewModel.cameraMode == .colorDetector else {
                    voiceRequestor.selectedVoiceRequest = .empty
                    return
                }
                let actionScreen = ActionScreen(screenType: .colorDetector)
                feedbackManager.generateGesturesReminder(for: actionScreen)
            default:
                voiceRequestor.selectedVoiceRequest = .empty
                return
            }
            
            voiceRequestor.selectedVoiceRequest = .empty
        }
        .addGesturesActions(toExecuteAfterEveryAction: {
            feedbackManager.generateHapticFeedbackForSwipeAction()
        }, onTap: {
            colorDetectorViewModel.readDetectedColor()
        }, onTrippleTap: {
            mainCameraRecognizerViewModel.speakCameraModeName()
        }, onLongPress: {
            voiceRecordingManager.manageTalking()
        }, onSwipeFromLeftToRight: {
            mainCameraRecognizerViewModel.changeToNextCameraMode()
        }, onSwipeFromRightToLeft: {
            mainCameraRecognizerViewModel.changeToPreviousCameraMode()
        }, onSwipeFromLeftToRightAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.chat)
        }, onSwipeFromRightToLeftAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.settings)
        })
    }
}

#Preview {
    ColorDetectorView()
}

private extension Views {
    struct Constants {
        static let colorLabelVerticalPadding: CGFloat = 15
        static let colorLabelBackgroundCornerRadius: CGFloat = 10
        static let colorToDisplayBottomPadding: CGFloat = 100
    }
}
