struct OpenAIVisionChatCompletionsRequestInputProvider: OpenAIVisionChatCompletionsRequestInputProviding {
    func getRequestInputFor(prompt: String, imageBase64String: String) -> OpenAIVisionChatCompletionsRequestInput {
        OpenAIVisionChatCompletionsRequestInput(messages: [
            OpenAIMessage(role: .user, content: [
                OpenAIMessageContent(type: .text, value: prompt),
                OpenAIMessageContent(type: .imageURL, value: imageBase64String)
            ])
        ])
    }
}

protocol OpenAIVisionChatCompletionsRequestInputProviding {
    func getRequestInputFor(prompt: String, imageBase64String: String) -> OpenAIVisionChatCompletionsRequestInput
}
