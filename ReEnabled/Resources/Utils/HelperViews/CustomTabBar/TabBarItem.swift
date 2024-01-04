enum TabBarItem: Hashable {
    case home
    case search
    case help
}

extension TabBarItem {
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .search:
            return "mic"
        case .help:
            return "questionmark.circle"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .help:
            return "Help"
        }
    }
}
