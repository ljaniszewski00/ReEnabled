import Foundation

func getAppLanguage() -> SupportedLanguage? {
    let languageIdentifier = Locale.preferredLanguageIdentifier
    return SupportedLanguage.getSupportedLanguageFrom(languageIdentifier: languageIdentifier)
}
