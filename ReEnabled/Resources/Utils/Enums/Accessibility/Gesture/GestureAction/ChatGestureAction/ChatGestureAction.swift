enum ChatGestureAction {
    case triggerConversationReading
    case triggerVoiceMessageRegisteringForChat
    case changeConversationToNext
    case changeConversationToPrevious
    case deleteCurrentConversation
    case selectPhoto
}

extension ChatGestureAction {
    var description: String {
        switch self {
        case .triggerConversationReading:
            "Trigger conversation reading"
        case .triggerVoiceMessageRegisteringForChat:
            "Trigger voice message registering for chat"
        case .changeConversationToNext:
            "Change conversation to next"
        case .changeConversationToPrevious:
            "Change conversation to previous"
        case .deleteCurrentConversation:
            "Delete current conversation"
        case .selectPhoto:
            "Select photo"
        }
    }
}
