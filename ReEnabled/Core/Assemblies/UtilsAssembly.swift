import Swinject

class UtilsAssembly: Assembly {

    func assemble(container: Container) {
        container.register(FeedbackManaging.self) { _ in
            FeedbackManager()
        }
        
        container.register(RealmManaging.self) { _ in
            RealmManager.shared
        }
    }
}
