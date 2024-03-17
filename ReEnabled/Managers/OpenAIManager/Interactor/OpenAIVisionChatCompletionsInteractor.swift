import Combine

class OpenAIVisionChatCompletionsInteractor: OpenAIVisionChatCompletionsInteracting {

    // MARK: - Init

    init(apiClient: AnyAPIClient<OpenAIVisionChatCompletionsRequestInput, OpenAIChatCompletionsResponse>) {
        self.apiClient = apiClient
    }

    // MARK: - Properties

    private let apiClient: AnyAPIClient<OpenAIVisionChatCompletionsRequestInput, OpenAIChatCompletionsResponse>

    // MARK: - OpenAIVisionChatCompletionsInteracting

    func generateResponse(prompt: String, imageBase64String: String) -> AnyPublisher<String?, Error> {
        let requestInput = OpenAIVisionChatCompletionsRequestInput(prompt: prompt, imageBase64String: imageBase64String)
        
        return apiClient
            .request(OpenAIEndpoints.visionChatCompletions, requestInput: requestInput)
            .map { response in response.choices.first?.message.content }
            .eraseToAnyPublisher()
    }

}

protocol OpenAIVisionChatCompletionsInteracting {
    func generateResponse(prompt: String, imageBase64String: String) -> AnyPublisher<String?, Error>
}
