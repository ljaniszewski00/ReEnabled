import Foundation

extension String {
    func localized() -> String {
        let fileType: String = "lproj"
        let tableName: String = "Localizable"
        
        if let appLanguage = getAppLanguage() {
            switch appLanguage {
            case .polish:
                guard let path = Bundle.main.path(forResource: SupportedLanguage.polish.identifier,
                                                  ofType: fileType),
                      let bundle = Bundle(path: path) else {
                    return ""
                }
                
                return NSLocalizedString(self,
                                         tableName: tableName,
                                         bundle: bundle,
                                         value: self,
                                         comment: self)
            default:
                guard let path = Bundle.main.path(forResource: SupportedLanguage.english.identifier,
                                                  ofType: fileType),
                      let bundle = Bundle(path: path) else {
                    return ""
                }
                
                return NSLocalizedString(self,
                                         tableName: tableName,
                                         bundle: bundle,
                                         value: self,
                                         comment: self)
            }
        } else {
            guard let path = Bundle.main.path(forResource: SupportedLanguage.english.identifier,
                                              ofType: fileType),
                  let bundle = Bundle(path: path) else {
                return ""
            }
            
            return NSLocalizedString(self,
                                     tableName: tableName,
                                     bundle: bundle,
                                     value: self,
                                     comment: self)
        }
    }
}
