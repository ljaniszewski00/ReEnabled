import SwiftUI

struct CustomTabBarView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    
    @Binding var selection: TabBarItem
    @State var localSelection: TabBarItem
    let tabs: [TabBarItem]
    
    var body: some View {
        if !tabBarStateManager.isHidden {
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    Button {
                        switchToTab(tab: tab)
                    } label: {
                        buildTabView(tab: tab)
                    }
                }
            }
            .padding(6)
            .padding([.horizontal, .bottom])
            .background (
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .onChange(of: selection) { value in
                withAnimation(.easeInOut) {
                    localSelection = selection
                }
            }
            .animation(.default)
            .transition(.move(edge: .bottom))
            .zIndex(1)
        }
    }
}

#Preview {
    let tabs: [TabBarItem] = [
        .home, .search, .help
    ]
    let tabBarStateManager = TabBarStateManager()
    return VStack {
        Spacer()
        CustomTabBarView(selection: .constant(tabs.first!),
                         localSelection: tabs.first!,
                         tabs: tabs)
        .environmentObject(tabBarStateManager)
    }
}

extension CustomTabBarView {
    private func buildTabView(tab: TabBarItem) -> some View {
        VStack(spacing: 5) {
            Image(systemName: tab.iconName)
                .symbolVariant(.fill)
                .font(.body.bold())
            Text(tab.title)
                .font(.system(size: 16))
                .lineLimit(1)
        }
        .foregroundColor(localSelection == tab ? .accentColor : .gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
}
