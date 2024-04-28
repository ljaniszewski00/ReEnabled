import Foundation
import RealmSwift

class SettingsObject: Object, ObjectKeyIdentifiable, RealmObjectProtocol {
    @Persisted(primaryKey: true) var id: String
    @Persisted var defaultCameraMode: CameraMode
    @Persisted var defaultDistanceMeasureUnit: DistanceMeasureUnit
    @Persisted var flashlightTriggerLightValue: Float?
    @Persisted var speechSpeed: Float
    @Persisted var speechVoiceType: SpeechVoiceType
    @Persisted var subscriptionPlan: SubscriptionPlan
}

extension SettingsObject {
    enum SettingsObjectKeys: String {
        case id
        case defaultCameraMode
        case defaultDistanceMeasureUnit
        case flashlightTriggerLightValue
        case speechSpeed
        case speechVoiceType
        case subscriptionPlan
    }
}

extension SettingsObject {
    var toModel: SettingsModel? {
        SettingsModel(id: id,
                      defaultCameraMode: defaultCameraMode,
                      defaultDistanceMeasureUnit: defaultDistanceMeasureUnit,
                      flashlightTriggerLightValue: flashlightTriggerLightValue,
                      speechSpeed: speechSpeed,
                      speechVoiceType: speechVoiceType,
                      subscriptionPlan: subscriptionPlan)
    }
}
