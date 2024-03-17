import Combine

class OpenAIVisionChatCompletionsInteractor: OpenAIVisionChatCompletionsInteracting {

    // MARK: - Init

    init(apiClient: AnyAPIClient<OpenAIVisionChatCompletionsRequestInput, OpenAIChatCompletionsResponse>,
         requestInputProvider: OpenAIVisionChatCompletionsRequestInputProviding) {
        self.apiClient = apiClient
        self.requestInputProvider = requestInputProvider
    }

    // MARK: - Properties

    private let apiClient: AnyAPIClient<OpenAIVisionChatCompletionsRequestInput, OpenAIChatCompletionsResponse>
    private let requestInputProvider: OpenAIVisionChatCompletionsRequestInputProviding

    // MARK: - OpenAIVisionChatCompletionsInteracting

    func generateResponse(prompt: String, imageBase64String: String) -> AnyPublisher<String?, Error> {
        let requestInput = requestInputProvider.getRequestInputFor(prompt: prompt, imageBase64String: imageBase64String)
        
        return apiClient
            .request(OpenAIEndpoints.visionChatCompletions, requestInput: requestInput)
            .map { response in response.choices.first?.message.content }
            .eraseToAnyPublisher()
    }

}

protocol OpenAIVisionChatCompletionsInteracting {
    func generateResponse(prompt: String, imageBase64String: String) -> AnyPublisher<String?, Error>
}
