import Foundation

extension String {
    func localized() -> String {
        if let appLanguage = LocalizationManager.shared.getAppLanguage() {
            switch appLanguage {
            case .english:
                guard let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
                      let bundle = Bundle(path: path) else {
                    return ""
                }
                
                return NSLocalizedString(self,
                                         tableName: "Localizable",
                                         bundle: bundle,
                                         value: self,
                                         comment: self)
            case .polish:
                guard let path = Bundle.main.path(forResource: "pl", ofType: "lproj"),
                      let bundle = Bundle(path: path) else {
                    return ""
                }
                
                return NSLocalizedString(self,
                                         tableName: "Localizable",
                                         bundle: bundle,
                                         value: self,
                                         comment: self)
            }
        } else {
            return ""
        }
    }
}
