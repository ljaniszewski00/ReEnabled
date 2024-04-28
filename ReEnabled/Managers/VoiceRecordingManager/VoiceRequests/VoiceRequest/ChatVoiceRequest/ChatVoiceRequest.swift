enum ChatVoiceRequest {
    case sendMessage
    case describePhoto
    case readConversation
    case saveCurrentConversation
    case deleteCurrentConversation
    case deleteAllConversations
}

extension ChatVoiceRequest {
    var rawValue: String {
        switch self {
        case .sendMessage:
            return VoiceRequestText.chatVoiceRequestSendMessage.rawValue.localized()
        case .describePhoto:
            return VoiceRequestText.chatVoiceRequestDescribePhoto.rawValue.localized()
        case .readConversation:
            return VoiceRequestText.chatVoiceRequestReadConversation.rawValue.localized()
        case .saveCurrentConversation:
            return VoiceRequestText.chatVoiceRequestSaveCurrentConversation.rawValue.localized()
        case .deleteCurrentConversation:
            return VoiceRequestText.chatVoiceRequestDeleteCurrentConversation.rawValue.localized()
        case .deleteAllConversations:
            return VoiceRequestText.chatVoiceRequestDeleteAllConversations.rawValue.localized()
        }
    }
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
