import Foundation

extension Locale {
    static var preferredLanguageIdentifier: String {
        guard let preferredLanguage = preferredLanguages.first,
              let identifier = Locale(identifier: preferredLanguage).language.languageCode?.identifier else {
            return "en"
        }
        
        return identifier
    }
}
