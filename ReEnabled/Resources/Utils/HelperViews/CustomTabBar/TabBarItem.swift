enum TabBarItem: Hashable {
    case camera
    case chat
    case settings
}

extension TabBarItem {
    var iconName: String {
        switch self {
        case .camera:
            return "camera"
        case .chat:
            return "mic"
        case .settings:
            return "gear"
        }
    }
    
    var title: String {
        switch self {
        case .camera:
            return OtherText.tabBarItemCamera.rawValue.localized()
        case .chat:
            return OtherText.tabBarItemChat.rawValue.localized()
        case .settings:
            return OtherText.tabBarItemSettings.rawValue.localized()
        }
    }
}
