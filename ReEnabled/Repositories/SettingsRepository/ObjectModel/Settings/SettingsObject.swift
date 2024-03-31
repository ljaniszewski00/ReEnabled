import Foundation
import RealmSwift

class SettingsObject: Object, ObjectKeyIdentifiable, RealmObjectProtocol {
    @Persisted(primaryKey: true) var id: String
    @Persisted var defaultCameraMode: CameraMode
    @Persisted var defaultDistanceMeasureUnit: DistanceMeasureUnit
    @Persisted var documentScannerLanguage: SupportedLanguage
    @Persisted var flashlightTriggerLightValue: Float?
    @Persisted var speechSpeed: Float
    @Persisted var speechVoiceType: SpeechVoiceType
    @Persisted var speechLanguage: SupportedLanguage
    @Persisted var voiceRecordingLanguage: SupportedLanguage
    @Persisted var subscriptionPlan: SubscriptionPlan
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
