import Foundation
import RealmSwift

class SettingsObject: Object, ObjectKeyIdentifiable, RealmObjectProtocol {
    @Persisted(primaryKey: true) var id: String
    @Persisted var defaultCameraMode: String
    @Persisted var defaultDistanceMeasureUnit: String
    @Persisted var documentScannerLanguage: String
    @Persisted var flashlightTriggerLightValue: Float?
    @Persisted var speechSpeed: Float
    @Persisted var speechVoiceType: String
    @Persisted var speechLanguage: String
    @Persisted var voiceRecordingLanguage: String
    @Persisted var subscriptionPlan: String
}

extension SettingsObject {
    enum SettingsObjectKeys: String {
        case id
        case defaultCameraMode
        case defaultDistanceMeasureUnit
        case documentScannerLanguage
        case flashlightTriggerLightValue
        case speechSpeed
        case speechVoiceType
        case speechLanguage
        case voiceRecordingLanguage
        case subscriptionPlan
    }
}

extension SettingsObject {
    var toModel: SettingsModel? {
        guard let defaultCameraMode = CameraMode(rawValue: defaultCameraMode),
              let defaultDistanceMeasureUnit = DistanceMeasureUnit(rawValue: defaultDistanceMeasureUnit),
              let documentScannerLanguage = SupportedLanguage.getSupportLanguageFrom(documentScannerLanguage),
              let speechVoiceType = SpeechVoiceType(rawValue: speechVoiceType),
              let speechLanguage = SupportedLanguage.getSupportLanguageFrom(speechLanguage),
              let voiceRecordingLanguage = SupportedLanguage.getSupportLanguageFrom(voiceRecordingLanguage),
              let subscriptionPlan = SubscriptionPlan(rawValue: subscriptionPlan) else {
            return nil
        }
        
        return SettingsModel(id: id,
                             defaultCameraMode: defaultCameraMode,
                             defaultDistanceMeasureUnit: defaultDistanceMeasureUnit,
                             documentScannerLanguage: documentScannerLanguage,
                             flashlightTriggerLightValue: flashlightTriggerLightValue,
                             speechSpeed: speechSpeed,
                             speechVoiceType: speechVoiceType,
                             speechLanguage: speechLanguage,
                             voiceRecordingLanguage: voiceRecordingLanguage,
                             subscriptionPlan: subscriptionPlan)
    }
}
