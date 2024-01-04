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
                        if tab == .search {
                            buildSearchTabView()
                        } else {
                            buildTabView(tab: tab)
                        }
                    }
                }
            }
            .padding(.vertical, Views.Constants.tabBarContentPadding)
            .padding(.bottom)
            .background (
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: Views.Constants.tabBarBackgroundCornerRadius,
                                     style: .continuous)
            )
            .shadow(color: Color.black.opacity(Views.Constants.tabBarShadowColorOpacity),
                    radius: Views.Constants.tabBarShadowRadius,
                    x: Views.Constants.tabBarShadowX,
                    y: Views.Constants.tabBarShadowY)
            .onChange(of: selection) { value in
                withAnimation(.easeInOut) {
                    localSelection = selection
                }
            }
            .animation(.spring())
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
                         localSelection: tabs[1],
                         tabs: tabs)
        .environmentObject(tabBarStateManager)
    }
}

extension CustomTabBarView {
    private func buildTabView(tab: TabBarItem) -> some View {
        VStack(spacing: Views.Constants.tabVStackSpacing) {
            Image(systemName: tab.iconName)
                .resizable()
                .symbolVariant(localSelection == tab ? .fill : .none)
                .frame(width: Views.Constants.tabHomeHelpImageFrameWidth,
                       height: Views.Constants.tabHomeHelpImageFrameHeight)
            
            if localSelection == tab {
                Text(tab.title)
                    .font(.system(size: Views.Constants.tabNameFontSize))
                    .lineLimit(Views.Constants.tabNameLineLimit)
            }
        }
        .foregroundColor(localSelection == tab ? .accentColor : .gray)
        .frame(maxWidth: .infinity)
    }
    
    private func buildSearchTabView() -> some View {
        VStack(spacing: Views.Constants.tabVStackSpacing) {
            Image(systemName: TabBarItem.search.iconName)
                .resizable()
                .symbolVariant(localSelection == .search ? .fill : .none)
                .frame(width: Views.Constants.tabSearchImageFrameWidth,
                       height: Views.Constants.tabSearchImageFrameHeight)
                .if(localSelection == .search) {
                    $0
                        .padding(Views.Constants.tabSearchSelectedBackgroundPadding)
                        .background (
                            .ultraThinMaterial,
                            in: Circle()
                        )
                        .clipShape(Circle())
                        .offset(y: Views.Constants.tabSearchSelectedOffset)
                        .padding(.bottom, Views.Constants.tabSearchSelectedBottomPadding)
                }
            
            if localSelection == .search {
                Text(TabBarItem.search.title)
                    .font(.system(size: Views.Constants.tabNameFontSize))
                    .lineLimit(Views.Constants.tabNameLineLimit)
            }
        }
        .foregroundColor(localSelection == .search ? .accentColor : .gray)
        .frame(maxWidth: .infinity)
    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
}

private extension Views {
    struct Constants {
        static let tabBarContentPadding: CGFloat = 10
        static let tabBarBackgroundCornerRadius: CGFloat = 10
        static let tabBarShadowColorOpacity: CGFloat = 0.3
        static let tabBarShadowRadius: CGFloat = 10
        static let tabBarShadowX: CGFloat = 0
        static let tabBarShadowY: CGFloat = 5
        
        static let tabVStackSpacing: CGFloat = 8
        static let tabHomeHelpImageFrameWidth: CGFloat = 30
        static let tabHomeHelpImageFrameHeight: CGFloat = 26
        static let tabNameFontSize: CGFloat = 16
        static let tabNameLineLimit: Int = 1
        
        static let tabSearchImageFrameWidth: CGFloat = 25
        static let tabSearchImageFrameHeight: CGFloat = 35
        static let tabSearchSelectedBackgroundPadding: CGFloat = 30
        static let tabSearchSelectedOffset: CGFloat = -69
        static let tabSearchSelectedBottomPadding: CGFloat = -69
    }
}
