import Foundation
import RealmSwift

struct SettingsModel: Equatable {
    var id: String = UUID().uuidString
    var defaultCameraMode: CameraMode
    var defaultDistanceMeasureUnit: DistanceMeasureUnit
    var documentScannerLanguage: SupportedLanguage
    var flashlightTriggerLightValue: Float?
    var speechSpeed: Float
    var speechVoiceType: SpeechVoiceType
    var speechLanguage: SupportedLanguage
    var voiceRecordingLanguage: SupportedLanguage
    var subscriptionPlan: SubscriptionPlan
    
    static func == (lhs: SettingsModel, rhs: SettingsModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension SettingsModel {
    var toObject: SettingsObject {
        return SettingsObject(value:
            [
                SettingsObject.SettingsObjectKeys.id.rawValue: id,
                SettingsObject.SettingsObjectKeys.defaultCameraMode.rawValue: defaultCameraMode.rawValue,
                SettingsObject.SettingsObjectKeys.defaultDistanceMeasureUnit.rawValue: defaultDistanceMeasureUnit.rawValue,
                SettingsObject.SettingsObjectKeys.documentScannerLanguage.rawValue: documentScannerLanguage.fullName,
                SettingsObject.SettingsObjectKeys.flashlightTriggerLightValue.rawValue: flashlightTriggerLightValue,
                SettingsObject.SettingsObjectKeys.speechSpeed.rawValue: speechSpeed,
                SettingsObject.SettingsObjectKeys.speechVoiceType.rawValue: speechVoiceType.rawValue,
                SettingsObject.SettingsObjectKeys.speechLanguage.rawValue: speechLanguage.fullName,
                SettingsObject.SettingsObjectKeys.voiceRecordingLanguage.rawValue: voiceRecordingLanguage.fullName,
                SettingsObject.SettingsObjectKeys.subscriptionPlan.rawValue: subscriptionPlan.rawValue
            ]
        )
    }
    
    static var defaultSettings: Self {
        SettingsModel(defaultCameraMode: .mainRecognizer,
                      defaultDistanceMeasureUnit: .meters,
                      documentScannerLanguage: .english,
                      flashlightTriggerLightValue: nil,
                      speechSpeed: 1.0,
                      speechVoiceType: .female,
                      speechLanguage: .english,
                      voiceRecordingLanguage: .english,
                      subscriptionPlan: .standard)
    }
}
