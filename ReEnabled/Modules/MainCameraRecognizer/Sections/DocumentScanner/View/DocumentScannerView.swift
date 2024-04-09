import SwiftUI

struct DocumentScannerView: View {
    @EnvironmentObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel
    
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    
    var body: some View {
        DocumentScannerViewControllerRepresentable()
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
    DocumentScannerView()
}
