import Foundation

public struct OpenAIChatCompletionsResponse: Codable, Equatable {
    let id: String
    let object: String
    let created: TimeInterval
    let model: String
    let choices: [Choice]
    let usage: Usage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case choices
        case usage
    }
}

struct Choice: Codable, Equatable {
    let index: Int
    let message: Chat
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}

struct Usage: Codable, Equatable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct Chat: Codable, Equatable {
    let role: OpenAIRole
    let content: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case name
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)

        if let name = name {
            try container.encode(name, forKey: .name)
        }

        if content != nil || role == .assistant {
            try container.encode(content, forKey: .content)
        }
    }
}
