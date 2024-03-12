import Foundation

class SearchViewModel: ObservableObject {
    @Published var currentMessageContent: String = ""
    @Published var currentConversation: Conversation
    @Published var conversations: [Conversation] = []
    
    @Published var showPreviousConversations: Bool = false
    
    init() {
//        self.currentConversation = Conversation(messages: [])
        self.currentConversation = Conversation.mockData
    }
    
    func uploadImage() {
        
    }
}
