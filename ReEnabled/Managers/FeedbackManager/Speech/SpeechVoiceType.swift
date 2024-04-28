import RealmSwift

enum SpeechVoiceType: PersistableEnum {
    case female
    case male
    
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case OtherText.speechVoiceTypeFemale.rawValue.localized() : self = .female
        case OtherText.speechVoiceTypeMale.rawValue.localized() : self = .male
        default: return nil
        }
    }
}

extension SpeechVoiceType {
    var rawValue: String {
        switch self {
        case .female:
            OtherText.speechVoiceTypeFemale.rawValue.localized()
        case .male:
            OtherText.speechVoiceTypeMale.rawValue.localized()
        }
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

extension SpeechVoiceType: CaseIterable {
    static var allCases: [SpeechVoiceType] {
        [
            .female,
            .male
        ]
    }
}
