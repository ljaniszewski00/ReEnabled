import SwiftUI

struct ContentView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @Inject private var feedbackManager: FeedbackManager
    @Inject private var voiceRecordingManager: VoiceRecordingManager
    
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
    }
}

#Preview {
    ContentView()
}
