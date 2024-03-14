import Swinject

class SearchAssembly: Assembly {

    func assemble(container: Container) {
        container.register(OpenAIManaging.self) { _ in
            OpenAIManager()
        }
    }
}
