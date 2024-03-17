import Foundation

struct OpenAIChatCompletionsRequestInput: Codable {
    let model: String = OpenAIModel.gpt3_5Turbo
    let messages: [OpenAIChatCompletionsMessage]
    let maxTokens: Int = 300
    
    init(prompt: String) {
        self.messages = [
            OpenAIChatCompletionsMessage(role: .user, content: prompt)
        ]
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

