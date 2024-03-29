import Swinject

class RepositoriesAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ConversationsRepositoryProtocol.self) { _ in
            ConversationsRepository()
        }
        
        container.register(SettingsRepositoryProtocol.self) { _ in
            SettingsRepository()
        }
    }
}
