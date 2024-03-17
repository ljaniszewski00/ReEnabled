import Swinject

class FeedbackManagerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(FeedbackManaging.self) { _ in
            FeedbackManager()
        }
    }
}
