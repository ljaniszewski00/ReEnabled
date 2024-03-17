import Combine

class OpenAIChatCompletionsInteractor: OpenAIChatCompletionsInteracting {

    // MARK: - Init

    init(apiClient: AnyAPIClient<OpenAIChatCompletionsRequestInput, OpenAIChatCompletionsResponse>) {
        self.apiClient = apiClient
    }

    // MARK: - Properties

    private let apiClient: AnyAPIClient<OpenAIChatCompletionsRequestInput, OpenAIChatCompletionsResponse>

    // MARK: - OpenAIChatCompletionsInteracting

    func generateResponse(prompt: String) -> AnyPublisher<String?, Error> {
        let requestInput = OpenAIChatCompletionsRequestInput(prompt: prompt)
        
        return apiClient
            .request(OpenAIEndpoints.chatCompletions, requestInput: requestInput)
            .map { response in response.choices.first?.message.content }
            .eraseToAnyPublisher()
    }

}

protocol OpenAIChatCompletionsInteracting {
    func generateResponse(prompt: String) -> AnyPublisher<String?, Error>
}
