import SwiftUI

struct ContentView: View {
    @StateObject private var tabBarStateManager = TabBarStateManager()
    
    private var selection: String {
        tabBarStateManager.tabSelection.title
    }
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabBarStateManager.tabSelection) {
            HomeView()
                .environmentObject(tabBarStateManager)
                .tabBarItem(tab: .camera,
                            selection: $tabBarStateManager.tabSelection)
            
            ChatView()
                .environmentObject(tabBarStateManager)
                .tabBarItem(tab: .chat,
                            selection: $tabBarStateManager.tabSelection)
            
            HelpView()
                .environmentObject(tabBarStateManager)
                .tabBarItem(tab: .settings,
                            selection: $tabBarStateManager.tabSelection)
        }
        .environmentObject(tabBarStateManager)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
