import Foundation

struct OpenAIChatCompletionsRequestInput: Codable {
    private let model: String = OpenAIModel.gpt3_5Turbo
    private let messages: [OpenAIChatCompletionsMessage]
    private let maxTokens: Int
    
    init(prompt: String, maxTokens: Int) {
        self.messages = [
            OpenAIChatCompletionsMessage(role: .user, content: prompt)
        ]
        self.maxTokens = maxTokens
    }
    
    enum CodingKeys: String, CodingKey {
        case model, messages
        case maxTokens = "max_tokens"
    }
}

struct OpenAIChatCompletionsMessage: Codable {
    let role: OpenAIRole
    let content: String
}

