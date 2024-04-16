import RealmSwift

enum SupportedLanguage: String, PersistableEnum {
    case english = "English"
    case polish = "Polish"
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
        
        switch self {
        case .english:
            if let voiceName = voiceName {
                sampleText = "Hi! My name is \(voiceName)."
            }
            
            sampleText += " What can I do for you?"
        case .polish:
            if let voiceName = voiceName {
                sampleText = "Cześć! Mam na imię \(voiceName)."
            }
            
            sampleText += " Co mogę dla Ciebie zrobić?"
        }
        
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
    
    static func getSupportedLanguageFrom(languageIdentifier: String?) -> Self? {
        allCases.first(where: { $0.identifier == languageIdentifier })
    }
}
