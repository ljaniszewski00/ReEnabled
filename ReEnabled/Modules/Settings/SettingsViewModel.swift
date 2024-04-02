import Combine
import Foundation
import RealmSwift

final class SettingsViewModel: ObservableObject {
    @Inject private var settingsRepository: SettingsRepositoryProtocol
    @Inject private var conversationsRepository: ConversationsRepositoryProtocol
    @Inject private var settingsProvider: SettingsProvider
    
    private var feedbackManager: FeedbackManager = .shared
    
    @Published var currentSettings: SettingsModel?
    
    let availableFlashlightTriggerValues: [String: Float] = [
        "Highest Tolerance": 5.0,
        "Medium Tolerance": 30.0,
        "Lowest Tolerance": 50.0
    ]
    
    var availableFlashlightTriggerValuesKeys: [String] = [
        "Highest Tolerance",
        "Medium Tolerance",
        "Lowest Tolerance"
    ]
    
    let availableSpeechSpeeds: [String: Float] = [
        "Fastest": 0.8,
        "Faster": 0.7,
        "Normal": 0.6,
        "Slower": 0.5,
        "Slowest": 0.4
    ]
    
    let availableSpeechSpeedsKeys: [String] = [
        "Fastest",
        "Faster",
        "Normal",
        "Slower",
        "Slowest"
    ]
    
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
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
        saveSettings()
    }
    
    func changeDefaultDistanceMeasureUnit(to newUnit: DistanceMeasureUnit) {
        currentSettings?.defaultDistanceMeasureUnit = newUnit
        saveSettings()
    }
    
    func changeDocumentScannerLanguage(to newDocumentScannerLanguage: SupportedLanguage) {
        currentSettings?.documentScannerLanguage = newDocumentScannerLanguage
        saveSettings()
    }
    
    func changeFlashlightTriggerMode(to newFlashlightTriggerMode: FlashlightTriggerMode) {
        switch newFlashlightTriggerMode {
        case .automatic:
            currentSettings?.flashlightTriggerLightValue = nil
        case .specificLightValue(let lightValue):
            currentSettings?.flashlightTriggerLightValue = lightValue
        }
        
        saveSettings()
    }
    
    func changeSpeechSpeed(to newSpeed: Float) {
        currentSettings?.speechSpeed = newSpeed
        saveSettings()
        feedbackManager.generateSampleSpeechFeedback()
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
        saveSettings()
    }
    
    func changeSubscriptionPlan(to newSubscriptionPlan: SubscriptionPlan) {
        currentSettings?.subscriptionPlan = newSubscriptionPlan
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
