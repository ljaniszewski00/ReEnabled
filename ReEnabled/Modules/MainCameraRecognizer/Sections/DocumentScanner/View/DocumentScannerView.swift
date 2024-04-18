import SwiftUI

struct DocumentScannerView: View {
    @EnvironmentObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel
    
    @StateObject private var documentScannerViewModel: DocumentScannerViewModel = DocumentScannerViewModel()
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    
    var body: some View {
        DocumentScannerViewControllerRepresentable(documentScannerViewModel: documentScannerViewModel)
            .overlay {
                Color.black
                    .opacity(Views.Constants.documentScannerControllerOverlayOpacity)
            }
            .contentShape(Rectangle())
            .addGesturesActions(toExecuteBeforeEveryAction: {
            }, toExecuteAfterEveryAction: {
                feedbackManager.generateHapticFeedbackForSwipeAction()
            }, onTap: {
                documentScannerViewModel.readDetectedTexts()
            }, onDoubleTap: {
                documentScannerViewModel.readDetectedBarCodesValues()
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

private extension Views {
    struct Constants {
        static let documentScannerControllerOverlayOpacity: CGFloat = 0.001
    }
}
