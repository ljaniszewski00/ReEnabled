import Foundation

struct OpenAIChatCompletionsRequestInput: Codable {
    let model: String = OpenAIModel.gpt3_5Turbo
    let messages: [OpenAIMessage]
    let maxTokens: Int = 300
    
    enum CodingKeys: String, CodingKey {
        case model, messages
        case maxTokens = "max_tokens"
    }
}
