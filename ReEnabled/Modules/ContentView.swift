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
            feedbackManager.generateSpeechFeedback(with: .other(.tabChangedTo),
                                                   and: newTab.title)
        }
        .onChange(of: voiceRecordingManager.transcript) { _, newTranscript in
            voiceRequestor.getVoiceRequest(from: newTranscript)
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
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
