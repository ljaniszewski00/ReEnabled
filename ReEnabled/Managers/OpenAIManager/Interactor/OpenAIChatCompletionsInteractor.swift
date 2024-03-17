import Combine

class OpenAIChatCompletionsInteractor: OpenAIChatCompletionsInteracting {

    // MARK: - Init

    init(apiClient: AnyAPIClient<OpenAIChatCompletionsRequestInput, OpenAIChatCompletionsResponse>,
         requestInputProvider: OpenAIChatCompletionsRequestInputProviding) {
        self.apiClient = apiClient
        self.requestInputProvider = requestInputProvider
    }

    // MARK: - Properties

    private let apiClient: AnyAPIClient<OpenAIChatCompletionsRequestInput, OpenAIChatCompletionsResponse>
    private let requestInputProvider: OpenAIChatCompletionsRequestInputProviding

    // MARK: - OpenAIChatCompletionsInteracting

    func generateResponse(prompt: String) -> AnyPublisher<String?, Error> {
        let requestInput = requestInputProvider.getRequestInputFor(prompt: prompt)
        
        return apiClient
            .request(OpenAIEndpoints.chatCompletions, requestInput: requestInput)
            .map { response in response.choices.first?.message.content }
            .eraseToAnyPublisher()
    }

}

protocol OpenAIChatCompletionsInteracting {
    func generateResponse(prompt: String) -> AnyPublisher<String?, Error>
}
