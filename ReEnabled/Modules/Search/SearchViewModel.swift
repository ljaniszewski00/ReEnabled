import Foundation

class SearchViewModel: ObservableObject {
    @Published var currentConversation: Conversation
    @Published var conversations: [Conversation] = []
    
    @Published var showPreviousConversations: Bool = false
    
    init() {
        self.currentConversation = Conversation(messages: [])
    }
    
    func addNewMessageWith(transcript: String) {
        guard !transcript.isEmpty else {
            return
        }
        
        let message: Message = Message(content: transcript, dateSent: Date(), sentByUser: true)
        currentConversation.messages.append(message)
    }
    
    func receiveNewMessage() {
        
    }
    
    func uploadImage() {
        
    }
}
