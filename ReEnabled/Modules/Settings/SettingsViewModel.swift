import Combine
import Foundation
import RealmSwift

final class SettingsViewModel: ObservableObject {
    @Inject private var settingsRepository: SettingsRepositoryProtocol
    @Inject private var conversationsRepository: ConversationsRepositoryProtocol
    @Inject private var settingsProvider: SettingsProvider
    
    private var feedbackManager: FeedbackManager = .shared
    
    @Published var currentSettings: SettingsModel?
    
    var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func getSettings(from settingsObjects: Results<SettingsObject>) {
        let fetchedSettings: SettingsModel? = settingsRepository.getSettings(from: settingsObjects)
        
        if let fetchedSettings = fetchedSettings {
            self.currentSettings = fetchedSettings
        } else {
            self.currentSettings = SettingsModel.defaultSettings
        }
    }
    
    func changeDefaultCameraMode(to newCameraMode: CameraMode) {
        currentSettings?.defaultCameraMode = newCameraMode
        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.defaultCameraModeHasBeenSetTo),
                                               and: newCameraMode.rawValue)
        saveSettings()
    }
    
    func changeDefaultDistanceMeasureUnit(to newUnit: DistanceMeasureUnit) {
        currentSettings?.defaultDistanceMeasureUnit = newUnit
        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.defaultMeasureUnitHasBeenSetTo),
                                               and: newUnit.rawValue)
        saveSettings()
    }
    
    func changeFlashlightTriggerMode(to newFlashlightTriggerMode: FlashlightTriggerMode) {
        switch newFlashlightTriggerMode {
        case .automatic:
            currentSettings?.flashlightTriggerLightValue = nil
            
        case .specificLightValue(let lightValue):
            currentSettings?.flashlightTriggerLightValue = lightValue.flashlightTriggerValue
        }
        
        saveSettings()
        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.flashlightTriggerModeHasBeenSetTo),
                                               and: newFlashlightTriggerMode.rawValue)
    }
    
    func changeSpeechSpeed(to newSpeed: SpeechSpeed) {
        currentSettings?.speechSpeed = newSpeed.speed
        saveSettings()
        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.speechSpeedHasBeenSetTo),
                                               and: newSpeed.rawValue)
    }
    
    func changeSpeechVoiceType(to newSpeechVoiceType: SpeechVoiceType) {
        currentSettings?.speechVoiceType = newSpeechVoiceType
        saveSettings()
        feedbackManager.generateSampleSpeechFeedback()
    }
    
    func changeSpeechLanguage(to newSpeechLanguage: SupportedLanguage) {
        currentSettings?.speechLanguage = newSpeechLanguage
        
        let speechVoiceTypeCases: [SpeechVoiceType] = newSpeechLanguage.supportedSpeechVoiceTypes
        if speechVoiceTypeCases.count == 1,
           let availableSpeechVoiceType = speechVoiceTypeCases.first {
            currentSettings?.speechVoiceType = availableSpeechVoiceType
        }
        
        saveSettings()
        feedbackManager.generateSampleSpeechFeedback()
    }
    
    func changeVoiceRecordingLanguage(to newVoiceRecordingLanguage: SupportedLanguage) {
        currentSettings?.voiceRecordingLanguage = newVoiceRecordingLanguage
        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.voiceRecordingLanguageHasBeenSetTo),
                                               and: newVoiceRecordingLanguage.rawValue)
        saveSettings()
    }
    
    func changeSubscriptionPlan(to newSubscriptionPlan: SubscriptionPlan) {
        currentSettings?.subscriptionPlan = newSubscriptionPlan
        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.subscriptionPlanHasBeenChangedTo),
                                               and: newSubscriptionPlan.rawValue)
        saveSettings()
    }
    
    func deleteAllConversations() -> AnyPublisher<Void, Never> {
        conversationsRepository.deleteAllConversations()
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }
    
    func restoreDefaultSettings() -> AnyPublisher<Void, Never> {
        self.currentSettings = SettingsModel.defaultSettings
        return settingsRepository.deleteAllSettings()
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }
    
    private func saveSettings() {
        guard let currentSettings = currentSettings else {
            return
        }
        
        settingsProvider.currentSettings = currentSettings
        settingsRepository.updateSettings(currentSettings)
    }
}
