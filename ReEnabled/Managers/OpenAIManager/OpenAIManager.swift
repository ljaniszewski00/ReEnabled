import Combine
import UIKit

class OpenAIManager: ObservableObject, OpenAIManaging {
    @Inject private var openAIChatCompletionsInteractor: OpenAIChatCompletionsInteracting
    @Inject private var openAIVisionChatCompletionsInteractor: OpenAIVisionChatCompletionsInteracting
    
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func generateResponse(for prompt: String) -> AnyPublisher<String?, Never> {
        openAIChatCompletionsInteractor
            .generateResponse(prompt: prompt)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    func generateImageResponse(for prompt: String, with image: UIImage) -> AnyPublisher<String?, Never> {
        guard let imageBase64String: String = image.base64 else {
            return Just(nil)
                .eraseToAnyPublisher()
        }
        
        return openAIVisionChatCompletionsInteractor
            .generateResponse(prompt: prompt, imageBase64String: imageBase64String)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

protocol OpenAIManaging {
    func generateResponse(for prompt: String) -> AnyPublisher<String?, Never>
    func generateImageResponse(for prompt: String, with image: UIImage) -> AnyPublisher<String?, Never>
}
