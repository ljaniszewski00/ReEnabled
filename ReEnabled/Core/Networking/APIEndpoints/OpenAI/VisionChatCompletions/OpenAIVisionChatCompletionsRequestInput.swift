import Foundation

struct OpenAIVisionChatCompletionsRequestInput: Codable {
    let model: String = OpenAIModel.gpt4_vision_preview
    let messages: [OpenAIVissionChatCompletionsMessage]
    let maxTokens: Int = 300
    
    init(prompt: String, imageBase64String: String) {
        self.messages = [
            OpenAIVissionChatCompletionsMessage(role: .user, content: [
                OpenAIMessageContent(type: .text, value: prompt),
                OpenAIMessageContent(type: .imageURL, value: imageBase64String)
            ])
        ]
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
