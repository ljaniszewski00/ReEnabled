import Swinject

class SearchAssembly: Assembly {

    func assemble(container: Container) {
        container.register(OpenAIManaging.self) { _ in
            OpenAIManager()
        }
        
        container.registerAPIClient(OpenAIChatCompletionsRequestInput.self, OpenAIChatCompletionsResponse.self)
        
        container.register(OpenAIChatCompletionsInteracting.self) { resolver in
            OpenAIChatCompletionsInteractor(apiClient: resolver.resolve(AnyAPIClient<OpenAIChatCompletionsRequestInput, OpenAIChatCompletionsResponse>.self)!)
        }
        
        container.registerAPIClient(OpenAIVisionChatCompletionsRequestInput.self, OpenAIChatCompletionsResponse.self)
        
        container.register(OpenAIVisionChatCompletionsInteracting.self) { resolver in
            OpenAIVisionChatCompletionsInteractor(apiClient: resolver.resolve(AnyAPIClient<OpenAIVisionChatCompletionsRequestInput, OpenAIChatCompletionsResponse>.self)!)
        }
    }
}
