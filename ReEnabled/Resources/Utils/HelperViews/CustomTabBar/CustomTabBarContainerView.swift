import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>,
         @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            CustomTabBarView(selection: $selection,
                             localSelection: selection,
                             tabs: tabs)
            .environmentObject(tabBarStateManager)
            .measureSize(size: $tabBarStateManager.tabBarSize)
            .onChange(of: tabBarStateManager.tabBarSize) { newSize in
                tabBarStateManager.changeTabBarValuesFor(tabBarNewSize: newSize)
            }
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

#Preview {
    let tabs: [TabBarItem] = [
        .camera, .search, .help
    ]
    let tabBarStateManager = TabBarStateManager()
    return VStack {
        Spacer()
        CustomTabBarContainerView(selection: .constant(tabs.first!)) {
            Color.red
        }
        .environmentObject(tabBarStateManager)
        Spacer()
    }
}
