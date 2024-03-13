enum SupportedLanguage {
    case english
    case polish
}

extension SupportedLanguage {
    var fullName: String {
        switch self {
        case .english:
            "English"
        case .polish:
            "Polish"
        }
    }
    
    var languageCode: String {
        switch self {
        case .english:
            "en-US"
        case .polish:
            "pl-PL"
        }
    }
    
    var identifier: String {
        switch self {
        case .english:
            "en"
        case .polish:
            "pl"
        }
    }
}
