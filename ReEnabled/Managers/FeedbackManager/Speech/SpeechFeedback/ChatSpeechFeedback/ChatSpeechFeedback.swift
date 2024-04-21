enum ChatSpeechFeedback: String {
    case welcomeHint = "Double tap to record a new message"
    
    case thisIsTheResponse = "This is the response"
    case conversationDeleted = "Current conversation has been deleted"
    case allConversationsDeleted = "All conversations have been deleted"
    case photoUploadedSayMessage = "Photo has been uploaded. Add a message before generating response or default one will be used which is about describing the photo"
    case photoUploaded = "Photo has been uploaded"
    case whatYouWantToKnow = "What you want to know?"
}
