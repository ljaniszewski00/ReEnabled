import SwiftUI

class TabBarStateManager: ObservableObject {
    @Published var tabSelection: TabBarItem = .chat
    @Published var isHidden = false
    @Published var tabBarSize: CGSize = .zero
    @Published var shouldAnimateChatTabIcon: Bool = false
    
    private init() {}
    
    static var shared: TabBarStateManager = {
        TabBarStateManager()
    }()
    
    var tabBarFirstAppearSet: Bool = false
    var tabBarActualSize: CGSize = .zero
    
    var screenBottomPaddingForViews: CGFloat {
        tabBarSize.height + 15
    }
    
    func changeTabSelectionTo(_ newTab: TabBarItem) {
        self.tabSelection = newTab
    }
    
    func hideTabBar() {
        isHidden = true
        tabBarSize = .zero
    }
    
    func showTabBar() {
        isHidden = false
    }
    
    func changeTabBarValuesFor(tabBarNewSize: CGSize) {
        if tabBarNewSize != .zero {
            if !tabBarFirstAppearSet {
                tabBarActualSize = tabBarNewSize
                tabBarFirstAppearSet = true
            } else {
                tabBarSize = tabBarActualSize
            }
        }
    }
}

extension TabBarStateManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
