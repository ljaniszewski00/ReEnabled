enum TabBarItem: Hashable {
    case camera
    case search
    case help
}

extension TabBarItem {
    var iconName: String {
        switch self {
        case .camera:
            return "camera"
        case .search:
            return "mic"
        case .help:
            return "questionmark.circle"
        }
    }
    
    var title: String {
        switch self {
        case .camera:
            return "Camera"
        case .search:
            return "Search"
        case .help:
            return "Help"
        }
    }
}
