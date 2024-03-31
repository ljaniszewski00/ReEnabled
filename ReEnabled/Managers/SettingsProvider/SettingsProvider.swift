import Combine
import Foundation

final class SettingsProvider: ObservableObject, SettingsProviding {
    @Inject private var settingsRepository: SettingsRepositoryProtocol
    
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private init() {
        fetchSettings()
    }
    
    static let shared: SettingsProviding = {
        SettingsProvider()
    }()
    
    @Published var currentSettings: SettingsModel = .defaultSettings
    
    var cameraMode: CameraMode {
        currentSettings.defaultCameraMode
    }
    
    var distanceMeasureUnit: DistanceMeasureUnit {
        currentSettings.defaultDistanceMeasureUnit
    }
    
    var documentScannerLanguage: SupportedLanguage {
        currentSettings.documentScannerLanguage
    }
    
    var flashlightTriggerMode: FlashlightTriggerMode {
        guard let flashlightTriggerLightValue = currentSettings.flashlightTriggerLightValue else {
            return .automatic
        }
        
        return .specificLightValue(flashlightTriggerLightValue)
    }
    
    var speechSpeed: Float {
        currentSettings.speechSpeed
    }
    
    var speechVoiceType: SpeechVoiceType {
        currentSettings.speechVoiceType
    }
    
    var speechLanguage: SupportedLanguage {
        currentSettings.speechLanguage
    }
    
    var voiceRecordingLanguage: SupportedLanguage {
        currentSettings.voiceRecordingLanguage
    }
    
    var subscriptionPlan: SubscriptionPlan {
        currentSettings.subscriptionPlan
    }
    
    private func fetchSettings() {
        settingsRepository.getSettings()
            .sink { _ in
            } receiveValue: { fetchedSettings in
                guard let fetchedSettings = fetchedSettings else {
                    return
                }
                
                self.currentSettings = fetchedSettings
            }
            .store(in: &cancelBag)

    }
}

protocol SettingsProviding {
    static var shared: SettingsProviding { get }
    
    var currentSettings: SettingsModel { get set }
    var cameraMode: CameraMode { get }
    var distanceMeasureUnit: DistanceMeasureUnit { get }
    var documentScannerLanguage: SupportedLanguage { get }
    var flashlightTriggerMode: FlashlightTriggerMode { get }
    var speechSpeed: Float { get }
    var speechVoiceType: SpeechVoiceType { get }
    var speechLanguage: SupportedLanguage { get }
    var voiceRecordingLanguage: SupportedLanguage { get }
    var subscriptionPlan: SubscriptionPlan { get }
}

extension SettingsProvider {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
