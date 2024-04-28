import RealmSwift

enum SupportedLanguage: PersistableEnum {
    case english
    case polish
    
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case OtherText.supportedLanguageEnglish.rawValue.localized() : self = .english
        case OtherText.supportedLanguagePolish.rawValue.localized() : self = .polish
        default: return nil
        }
    }
}

extension SupportedLanguage {
    var rawValue: String {
        switch self {
        case .english:
            OtherText.supportedLanguageEnglish.rawValue.localized()
        case .polish:
            OtherText.supportedLanguagePolish.rawValue.localized()
        }
    }
    
    var fullName: String {
        switch self {
        case .english:
            OtherText.supportedLanguageEnglish.rawValue.localized()
        case .polish:
            OtherText.supportedLanguagePolish.rawValue.localized()
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
    
    var supportedSpeechVoiceTypes: [SpeechVoiceType] {
        switch self {
        case .english:
            return [.female, .male]
        case .polish:
            return [.female]
        }
    }
    
    func getSpeechVoiceSampleText(voiceName: String?) -> String {
        var sampleText: String = ""
        
        if let voiceName = voiceName {
            sampleText = "\(OtherText.supportedLanguageHiMyNameIs.rawValue.localized()) \(voiceName)."
        }
        
        sampleText += " \(OtherText.supportedLanguageWhatCanIDoForYou.rawValue.localized())"
        
        return sampleText
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

extension SupportedLanguage {
    static func getSupportedLanguageFrom(languageIdentifier: String?) -> Self? {
        allCases.first(where: { $0.identifier == languageIdentifier })
    }
}
