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
                        if tab == .chat {
                            buildChatTabView()
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
        .camera, .chat, .settings
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
                .if(tab == .camera) {
                    $0.frame(width: Views.Constants.tabCameraImageFrameWidth,
                             height: Views.Constants.tabCameraImageFrameHeight)
                    
                }
                .if(tab == .settings) {
                    $0.frame(width: Views.Constants.tabHelpImageFrameWidth,
                             height: Views.Constants.tabHelpImageFrameHeight)
                }
            
            if localSelection == tab {
                Text(tab.title)
                    .font(.system(size: Views.Constants.tabNameFontSize))
                    .lineLimit(Views.Constants.tabNameLineLimit)
            }
        }
        .foregroundColor(localSelection == tab ? .accentColor : .gray)
        .frame(height: Views.Constants.tabFrameHeight)
        .frame(maxWidth: .infinity)
    }
    
    private func buildChatTabView() -> some View {
        VStack(spacing: Views.Constants.tabVStackSpacing) {
            Image(systemName: TabBarItem.chat.iconName)
                .resizable()
                .symbolVariant(localSelection == .chat ? .fill : .none)
                .frame(width: Views.Constants.tabSearchImageFrameWidth,
                       height: Views.Constants.tabSearchImageFrameHeight)
                .if(localSelection == .chat) {
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
            
            if localSelection == .chat {
                Text(TabBarItem.chat.title)
                    .font(.system(size: Views.Constants.tabNameFontSize))
                    .lineLimit(Views.Constants.tabNameLineLimit)
            }
        }
        .foregroundColor(localSelection == .chat ? .accentColor : .gray)
        .frame(height: Views.Constants.tabFrameHeight)
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
        static let tabCameraImageFrameWidth: CGFloat = 30
        static let tabCameraImageFrameHeight: CGFloat = 24
        static let tabHelpImageFrameWidth: CGFloat = 30
        static let tabHelpImageFrameHeight: CGFloat = 30
        static let tabNameFontSize: CGFloat = 16
        static let tabNameLineLimit: Int = 1
        static let tabFrameHeight: CGFloat = 50
        
        static let tabSearchImageFrameWidth: CGFloat = 25
        static let tabSearchImageFrameHeight: CGFloat = 35
        static let tabSearchSelectedBackgroundPadding: CGFloat = 30
        static let tabSearchSelectedOffset: CGFloat = -69
        static let tabSearchSelectedBottomPadding: CGFloat = -69
    }
}
