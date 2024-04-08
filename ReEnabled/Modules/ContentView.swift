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
                feedbackManager.generateSpeechFeedback(with: newTab.title)
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
                $0.blur(radius: 2.0)
            }
            
            if voiceRecordingManager.shouldDisplayVoiceCommandPreviewView {
                Views.VoiceCommandPreviewView()
                    .addGesturesActions(toExecuteBeforeEveryAction: {
                        feedbackManager.generateHapticFeedbackForSwipeAction()
                    }, onTrippleTap: {
                        voiceRecordingManager.manageTalking()
                    })
                    .zIndex(1)
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
    }
    
    struct VoiceCommandPreviewView: View {
        @State private var shouldAnimate: Bool = true
        
        var body: some View {
            Color.black
                .opacity(Views.Constants.voiceCommandPreviewViewOpacity)
                .ignoresSafeArea()
            
            Image(systemName: "waveform.badge.mic")
            .resizable()
            .symbolEffect(.pulse,
                          options: .repeating,
                          value: shouldAnimate)
            .frame(width: 80, height: 80)
            .padding()
            .frame(width: 300, height: 300)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.ultraThinMaterial)
            }
        }
    }
}
