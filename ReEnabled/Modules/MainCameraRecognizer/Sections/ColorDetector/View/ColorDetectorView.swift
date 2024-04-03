import SwiftUI

struct ColorDetectorView: View {
    @EnvironmentObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel
    
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    
    @StateObject private var colorDetectorViewModel: ColorDetectorViewModel = ColorDetectorViewModel()
    
    var body: some View {
        ZStack {
            ColorDetectorViewControllerRepresentable(colorDetectorViewModel: colorDetectorViewModel)
                .opacity(colorDetectorViewModel.canDisplayCamera ? 1 : 0)
            
            VStack {
                Spacer()
                
                if let colorName = colorDetectorViewModel.detectedColorName {
                    Text(colorName)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.bottom, Views.Constants.colorToDisplayBottomPadding)
                }
            }
        }
        .onTwoTouchSwipe(direction: .up, onSwipe: {
            voiceRecordingManager.manageTalking()
        })
        .addGesturesActions(toExecuteAfterEveryAction: {
            feedbackManager.generateHapticFeedbackForSwipeAction()
        }, onTap: {
            if let colorName = colorDetectorViewModel.detectedColorName {
                feedbackManager.generateSpeechFeedback(with: colorName)
            }
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
        static let colorToDisplayBottomPadding: CGFloat = 100
    }
}
