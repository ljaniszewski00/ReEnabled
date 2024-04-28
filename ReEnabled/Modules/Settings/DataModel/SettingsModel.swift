import Foundation
import RealmSwift

struct SettingsModel: Equatable {
    var id: String = UUID().uuidString
    var defaultCameraMode: CameraMode
    var defaultDistanceMeasureUnit: DistanceMeasureUnit
    var flashlightTriggerLightValue: Float?
    var speechSpeed: Float
    var speechVoiceType: SpeechVoiceType
    var subscriptionPlan: SubscriptionPlan
    
    static func == (lhs: SettingsModel, rhs: SettingsModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension SettingsModel {
    var toObject: SettingsObject {
        SettingsObject(value:
            [
                SettingsObject.SettingsObjectKeys.id.rawValue: id,
                SettingsObject.SettingsObjectKeys.defaultCameraMode.rawValue: defaultCameraMode.rawValue,
                SettingsObject.SettingsObjectKeys.defaultDistanceMeasureUnit.rawValue: defaultDistanceMeasureUnit.rawValue,
                SettingsObject.SettingsObjectKeys.flashlightTriggerLightValue.rawValue: flashlightTriggerLightValue,
                SettingsObject.SettingsObjectKeys.speechSpeed.rawValue: speechSpeed,
                SettingsObject.SettingsObjectKeys.speechVoiceType.rawValue: speechVoiceType.rawValue,
                SettingsObject.SettingsObjectKeys.subscriptionPlan.rawValue: subscriptionPlan.rawValue
            ]
        )
    }
    
    static var defaultSettings: Self {
        let languageIdentifier = Locale.current.language.languageCode?.identifier
        let deviceLanguage: SupportedLanguage? = .getSupportedLanguageFrom(languageIdentifier: languageIdentifier)
        
        return SettingsModel(defaultCameraMode: .mainRecognizer,
                             defaultDistanceMeasureUnit: .meters,
                             flashlightTriggerLightValue: nil,
                             speechSpeed: 0.5,
                             speechVoiceType: .female,
                             subscriptionPlan: .standard)
    }
}
