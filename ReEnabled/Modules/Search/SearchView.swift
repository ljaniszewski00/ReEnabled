import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
        }
        .environmentObject(tabBarStateManager)
    }
}

#Preview {
    let tabBarStateManager: TabBarStateManager = TabBarStateManager()
    
    return SearchView()
        .environmentObject(tabBarStateManager)
}
