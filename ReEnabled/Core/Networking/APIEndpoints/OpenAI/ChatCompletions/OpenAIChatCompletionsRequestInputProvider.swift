struct OpenAIChatCompletionsRequestInputProvider: OpenAIChatCompletionsRequestInputProviding {
    func getRequestInputFor(prompt: String) -> OpenAIChatCompletionsRequestInput {
        OpenAIChatCompletionsRequestInput(messages: [
            OpenAIMessage(role: .user, content: [
                OpenAIMessageContent(type: .text, value: prompt)
            ])
        ])
    }
}

protocol OpenAIChatCompletionsRequestInputProviding {
    func getRequestInputFor(prompt: String) -> OpenAIChatCompletionsRequestInput
}
