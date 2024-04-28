enum ChatSpeechFeedback {
    case welcomeHint
    case thisIsTheResponse
    case conversationDeleted
    case allConversationsDeleted
    case photoUploadedSayMessage
    case photoUploaded
    case whatYouWantToKnow
}

extension ChatSpeechFeedback {
    var rawValue: String {
        switch self {
        case .welcomeHint:
            return SpeechFeedbackText.chatSpeechFeedbackWelcomeHint.rawValue.localized()
        case .thisIsTheResponse:
            return SpeechFeedbackText.chatSpeechFeedbackThisIsTheResponse.rawValue.localized()
        case .conversationDeleted:
            return SpeechFeedbackText.chatSpeechFeedbackConversationDeleted.rawValue.localized()
        case .allConversationsDeleted:
            return SpeechFeedbackText.chatSpeechFeedbackAllConversationsDeleted.rawValue.localized()
        case .photoUploadedSayMessage:
            return SpeechFeedbackText.chatSpeechFeedbackPhotoUploadedSayMessage.rawValue.localized()
        case .photoUploaded:
            return SpeechFeedbackText.chatSpeechFeedbackPhotoUploaded.rawValue.localized()
        case .whatYouWantToKnow:
            return SpeechFeedbackText.chatSpeechFeedbackWhatYouWantToKnow.rawValue.localized()
        }
    }
}
