import SwiftUI

struct DocumentScannerView: View {
    @EnvironmentObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel
    
    @StateObject private var documentScannerViewModel: DocumentScannerViewModel = DocumentScannerViewModel()
    
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var voiceRequestor: VoiceRequestor = .shared
    
    var body: some View {
        DocumentScannerViewControllerRepresentable(documentScannerViewModel: documentScannerViewModel)
            .overlay {
                Color.black
                    .opacity(Views.Constants.documentScannerControllerOverlayOpacity)
            }
            .contentShape(Rectangle())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    feedbackManager.generateSpeechFeedback(with: .camera(.documentScanner(.welcomeHint)))
                }
            }
            .onChange(of: voiceRequestor.selectedVoiceRequest) { _, voiceRequest in
                guard voiceRequest != VoiceRequest.empty else {
                    return
                }
                
                switch voiceRequest {
                case .camera(.documentScanner(.readText)):
                    documentScannerViewModel.readDetectedTexts()
                case .camera(.documentScanner(.readBarCodes)):
                    documentScannerViewModel.readDetectedBarCodesValues()
                case .other(.remindVoiceCommands):
                    guard tabBarStateManager.tabSelection == .camera && mainCameraRecognizerViewModel.cameraMode == .documentScanner else {
                        voiceRequestor.selectedVoiceRequest = .empty
                        return
                    }
                    
                    let actionScreen = ActionScreen(screenType: .documentScanner)
                    feedbackManager.generateVoiceRequestsReminder(for: actionScreen)
                case .other(.remindGestures):
                    guard tabBarStateManager.tabSelection == .camera && mainCameraRecognizerViewModel.cameraMode == .documentScanner else {
                        voiceRequestor.selectedVoiceRequest = .empty
                        return
                    }
                    let actionScreen = ActionScreen(screenType: .documentScanner)
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
