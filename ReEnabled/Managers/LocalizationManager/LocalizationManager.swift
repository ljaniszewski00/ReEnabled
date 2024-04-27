import Foundation

class LocalizationManager {
    private let userDefaults: UserDefaults = .standard
    
    private init() {}
    
    static let shared: LocalizationManager = {
        LocalizationManager()
    }()
    
    func setAppLanguage(_ language: SupportedLanguage) {
        userDefaults.set(language.languageLabelForManager,
                         forKey: UserDefaultsKeys.KEY_AppLanguage)
        userDefaults.synchronize()
    }
    
    func getAppLanguage() -> SupportedLanguage? {
        guard let languageLabel = userDefaults.value(forKey: UserDefaultsKeys.KEY_AppLanguage) as? Int else {
            return nil
        }
        
        
    
        print()
        print(SupportedLanguage.getSupportedLanguageFrom(labelForManager: languageLabel))
        print()
        
        return SupportedLanguage.getSupportedLanguageFrom(labelForManager: languageLabel)
    }
    
    func removeAppLanguage() {
        userDefaults.removeObject(forKey: UserDefaultsKeys.KEY_AppLanguage)
        userDefaults.synchronize()
    }
}

extension LocalizationManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
