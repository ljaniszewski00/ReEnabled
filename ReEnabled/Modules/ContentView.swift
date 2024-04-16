import SwiftUI

struct ContentView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var voiceRequestor: VoiceRequestor = .shared
    
    private var selection: String {
        tabBarStateManager.tabSelection.title
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            CustomTabBarContainerView(selection: $tabBarStateManager.tabSelection) {
                MainCameraRecognizerView()
                    .tabBarItem(tab: .camera,
                                selection: $tabBarStateManager.tabSelection)
                
                ChatView()
                    .tabBarItem(tab: .chat,
                                selection: $tabBarStateManager.tabSelection)
                
                SettingsView()
                    .tabBarItem(tab: .settings,
                                selection: $tabBarStateManager.tabSelection)
            }
            .onChange(of: tabBarStateManager.tabSelection) { _, newTab in
                if newTab != .camera {
                    feedbackManager.generateSpeechFeedback(with: newTab.title)
                }
            }
            .onChange(of: voiceRecordingManager.transcript) { _, newTranscript in
                voiceRequestor.getVoiceRequest(from: newTranscript)
            }
            .onChange(of: voiceRecordingManager.isRecording) { _, isRecording in
                isRecording ? voiceRecordingManager.enableVoiceCommandPreviewView() : voiceRecordingManager.disableVoiceCommandPreviewView()
            }
            .onChange(of: voiceRequestor.selectedVoiceRequest) { _, voiceRequest in
                guard voiceRequest != VoiceRequest.empty else {
                    return
                }
                
                switch voiceRequest {
                case .other(.changeTabToCamera):
                    tabBarStateManager.changeTabSelectionTo(.camera)
                case .other(.changeTabToChat):
                    tabBarStateManager.changeTabSelectionTo(.chat)
                case .other(.changeTabToSettings):
                    tabBarStateManager.changeTabSelectionTo(.settings)
                default:
                    return
                }
            }
            .if(voiceRecordingManager.shouldDisplayVoiceCommandPreviewView) {
                $0.blur(radius: Views.Constants.conditionalContentBlurRadius)
            }
            
            if voiceRecordingManager.shouldDisplayVoiceCommandPreviewView {
                Views.VoiceCommandPreviewView()
                    .addGesturesActions(toExecuteBeforeEveryAction: {
                        feedbackManager.generateHapticFeedbackForSwipeAction()
                    }, onLongPress: {
                        voiceRecordingManager.manageTalking()
                    })
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

private extension Views {
    struct Constants {
        static let voiceCommandPreviewViewOpacity: CGFloat = 0.7
        static let conditionalContentBlurRadius: CGFloat = 2.0
        
        static let voiceCommandPreviewViewImageName: String = "waveform.badge.mic"
        static let voiceCommandPreviewViewImageSize: CGFloat = 120
        static let voiceCommandPreviewViewBackgroundCornerRadius: CGFloat = 10
        static let voiceCommandPreviewViewFrameSize: CGFloat = 300
    }
    
    struct VoiceCommandPreviewView: View {
        var body: some View {
            Color.black
                .opacity(Views.Constants.voiceCommandPreviewViewOpacity)
                .ignoresSafeArea()
            
            Image(systemName: Views.Constants.voiceCommandPreviewViewImageName)
            .resizable()
            .symbolEffect(.pulse,
                          options: .repeating)
            .frame(width: Views.Constants.voiceCommandPreviewViewImageSize,
                   height: Views.Constants.voiceCommandPreviewViewImageSize)
            .padding()
            .frame(width: Views.Constants.voiceCommandPreviewViewFrameSize,
                   height: Views.Constants.voiceCommandPreviewViewFrameSize)
            .background {
                RoundedRectangle(cornerRadius: Views.Constants.voiceCommandPreviewViewBackgroundCornerRadius)
                    .foregroundStyle(.ultraThinMaterial)
            }
        }
    }
}
