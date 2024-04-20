import Combine
import Foundation

final class SettingsProvider: ObservableObject {
    @Inject private var settingsRepository: SettingsRepositoryProtocol
    @Published var currentSettings: SettingsModel = .defaultSettings
    
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private init() {
        fetchSettings()
    }
    
    static let shared: SettingsProvider = {
        SettingsProvider()
    }()
    
    var cameraMode: CameraMode {
        currentSettings.defaultCameraMode
    }
    
    var distanceMeasureUnit: DistanceMeasureUnit {
        currentSettings.defaultDistanceMeasureUnit
    }
    
    var flashlightTriggerMode: FlashlightTriggerMode {
        guard let flashlightTriggerLightValue = currentSettings.flashlightTriggerLightValue,
              let flashlightTriggerLightValueKey = ManualFlashlightTriggerValue.getFlashlighTriggerLightValueFrom(flashlightTriggerLightValue) else {
            return .automatic
        }
        
        return .specificLightValue(flashlightTriggerLightValueKey)
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

extension SettingsProvider {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
