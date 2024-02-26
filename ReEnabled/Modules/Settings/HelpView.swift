import SwiftUI

struct HelpView: View {
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
    
    return HelpView()
        .environmentObject(tabBarStateManager)
}
