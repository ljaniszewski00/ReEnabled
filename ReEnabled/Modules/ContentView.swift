import SwiftUI

struct ContentView: View {
    @StateObject private var tabBarStateManager = TabBarStateManager()
    @State private var tabSelection: TabBarItem = .camera
    
    private var selection: String {
        tabSelection.title
    }
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            HomeView()
                .environmentObject(tabBarStateManager)
                .tabBarItem(tab: .camera,
                            selection: $tabSelection)
            
            SearchView()
                .environmentObject(tabBarStateManager)
                .tabBarItem(tab: .search,
                            selection: $tabSelection)
            
            HelpView()
                .environmentObject(tabBarStateManager)
                .tabBarItem(tab: .help,
                            selection: $tabSelection)
        }
        .environmentObject(tabBarStateManager)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}