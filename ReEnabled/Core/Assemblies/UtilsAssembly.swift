import Swinject

class UtilsAssembly: Assembly {

    func assemble(container: Container) {
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
    }
}
