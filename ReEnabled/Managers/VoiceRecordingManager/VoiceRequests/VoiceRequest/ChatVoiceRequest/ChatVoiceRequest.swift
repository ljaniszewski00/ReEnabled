enum ChatVoiceRequest: String {
    case sendMessage = "Send message"
    case describePhoto = "Describe photo"
    case readConversation = "Read conversation"
    case saveCurrentConversation = "Save current conversation"
    case deleteCurrentConversation = "Delete current conversation"
    case deleteAllConversations = "Delete all conversations"
}

extension ChatVoiceRequest {
    static let allCases: [VoiceRequest] = [
        .chat(.sendMessage),
        .chat(.describePhoto),
        .chat(.readConversation),
        .chat(.saveCurrentConversation),
        .chat(.deleteCurrentConversation),
        .chat(.deleteAllConversations)
    ]
}
