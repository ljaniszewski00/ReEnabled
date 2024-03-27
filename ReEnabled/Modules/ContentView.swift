import SwiftUI

struct ContentView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    
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
        .ignoresSafeArea(edges: .bottom)
        .onChange(of: tabBarStateManager.shouldAnimateChatTabIcon) { _, _ in
            feedbackManager.generateHapticFeedbackForMicrophoneUsage()
        }
    }
}

#Preview {
    ContentView()
}
