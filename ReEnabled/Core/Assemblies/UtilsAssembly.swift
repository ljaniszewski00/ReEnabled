import Swinject

class UtilsAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(HapticFeedbackGenerating.self) { _ in
            HapticFeedbackGenerator()
        }

        container.register(ContinuousHapticFeedbackGenerating.self) { resolver in
            ContinuousHapticFeedbackGenerator(generator: resolver.resolve(HapticFeedbackGenerating.self)!)
        }
        
        container.register(SpeechFeedbackGenerating.self) { _ in
            SpeechFeedbackGenerator()
        }
        
        container.register(FeedbackManager.self) { _ in
            FeedbackManager.shared
        }
        
        container.register(TabBarStateManager.self) { _ in
            TabBarStateManager.shared
        }
        
        container.register(VoiceRecordingManager.self) { _ in
            VoiceRecordingManager.shared
        }
        
        container.register(RealmManaging.self) { _ in
            RealmManager.shared
        }
        
        container.register(SettingsProviding.self) { _ in
            SettingsProvider.shared
        }
    }
}
