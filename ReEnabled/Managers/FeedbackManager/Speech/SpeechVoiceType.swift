import RealmSwift

enum SpeechVoiceType: String, PersistableEnum {
    case female = "Female"
    case male = "Male"    
}

extension SpeechVoiceType: CaseIterable {
    static var allCases: [SpeechVoiceType] {
        [
            .female,
            .male
        ]
    }
    
    func getVoiceName(for language: SupportedLanguage) -> String {
        switch language {
        case .english:
            switch self {
            case .female:
                return "Siri"
            case .male:
                return "Siri"
            }
        case .polish:
            return "Zosia"
        }
    }
    
    func getVoiceIdentifier(for language: SupportedLanguage) -> String {
        switch language {
        case .english:
            switch self {
            case .female:
                return "com.apple.ttsbundle.siri_female_en-GB_compact"
            case .male:
                return "com.apple.ttsbundle.siri_male_en-GB_compact"
            }
        case .polish:
            return "Zosia"
        }
    }
}
