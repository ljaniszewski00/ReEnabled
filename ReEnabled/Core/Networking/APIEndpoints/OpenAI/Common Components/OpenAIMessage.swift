struct OpenAIMessage: Codable {
    let role: OpenAIRole
    let content: [OpenAIMessageContent]
}
