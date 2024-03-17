import Foundation

struct OpenAIVisionChatCompletionsRequestInput: Codable {
    private let model: String = OpenAIModel.gpt4_vision_preview
    private let messages: [OpenAIVissionChatCompletionsMessage]
    private let maxTokens: Int
    
    init(prompt: String, imageBase64String: String, maxTokens: Int) {
        self.messages = [
            OpenAIVissionChatCompletionsMessage(role: .user, content: [
                OpenAIMessageContent(type: .text, value: prompt),
                OpenAIMessageContent(type: .imageURL, value: imageBase64String)
            ])
        ]
        self.maxTokens = maxTokens
    }
    
    enum CodingKeys: String, CodingKey {
        case model, messages
        case maxTokens = "max_tokens"
    }
}

struct OpenAIVissionChatCompletionsMessage: Codable {
    let role: OpenAIRole
    let content: [OpenAIMessageContent]
}
