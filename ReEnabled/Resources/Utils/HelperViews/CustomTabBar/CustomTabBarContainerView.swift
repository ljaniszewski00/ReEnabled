import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    @StateObject var tabBarStateManager: TabBarStateManager = .shared
    
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
            .measureSize(size: $tabBarStateManager.tabBarSize)
            .onChange(of: tabBarStateManager.tabBarSize) { _, newSize in
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
        .camera, .chat, .settings
    ]
    
    return VStack {
        Spacer()
        CustomTabBarContainerView(selection: .constant(tabs.first!)) {
            Color.red
        }
        Spacer()
    }
}
