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
        case .triggerConversationReading: GestureActionText.chatGestureActionTriggerConversationReadingDescription.rawValue.localized()
        case .triggerVoiceMessageRegisteringForChat: GestureActionText.chatGestureActionTriggerVoiceMessageRegisteringForChatDescription.rawValue.localized()
        case .changeConversationToNext: GestureActionText.chatGestureActionChangeConversationToNextDescription.rawValue.localized()
        case .changeConversationToPrevious: GestureActionText.chatGestureActionChangeConversationToPreviousDescription.rawValue.localized()
        case .deleteCurrentConversation: GestureActionText.chatGestureActionDeleteCurrentConversationDescription.rawValue.localized()
        case .selectPhoto: GestureActionText.chatGestureActionSelectPhotoDescription.rawValue.localized()
        }
    }
}
