import Foundation

struct OpenAIVisionChatCompletionsRequestInput: Codable {
    let model: String = OpenAIModel.gpt4_vision_preview
    let messages: [OpenAIMessage]
    let maxTokens: Int = 300
    
    enum CodingKeys: String, CodingKey {
        case model, messages
        case maxTokens = "max_tokens"
    }
}




