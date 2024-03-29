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
    
    static func getSupportLanguageFrom(_ value: String) -> Self? {
        if self.english.fullName == value {
            return self.english
        } else if self.polish.fullName == value {
            return self.polish
        } else {
            return nil
        }
    }
}

extension SupportedLanguage: CaseIterable {
    static var allCases: [SupportedLanguage] {
        [
            .english,
            .polish
        ]
    }
}
