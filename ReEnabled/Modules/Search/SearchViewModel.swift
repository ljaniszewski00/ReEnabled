import Foundation

class SearchViewModel: ObservableObject {
    @Published var currentConversation: Conversation = Conversation(messages: [])
    @Published var conversations: [Conversation] = [Conversation]()
    
    @Published var speechRecordingBlocked: Bool = false
    @Published var showPreviousConversations: Bool = false
    
    private let gpt2: GPT2 = GPT2(strategy: .topK(40))
    
    func saveCurrentConversation() {
        let conversationsIds: [String] = conversations.map { $0.id }
        if !currentConversation.messages.isEmpty && !conversationsIds.contains(currentConversation.id) {
            conversations.append(currentConversation)
        }
    }
    
    func addNewMessageWith(transcript: String) {
        guard !transcript.isEmpty else {
            return
        }
        
        let message: Message = Message(content: transcript, sentByUser: true)
        addMessageToCurrentConversation(message)
        
        generateResponseWith(searchMLModel: .gpt2, for: transcript)
    }
    
    private func generateResponseWith(searchMLModel: SearchMLModelFile, for query: String) {
        switch searchMLModel {
        case .gpt2:
            generateResponseWithGPT2(gpt2, for: query)
        }
    }
    
    private func generateResponseWithGPT2(_ gpt2: GPT2, for query: String) {
        speechRecordingBlocked = true
        DispatchQueue.global(qos: .userInitiated).async {
            let response = self.gpt2.generate(text: query, nTokens: 50) { _, _ in }
            
            DispatchQueue.main.async { [weak self] in
                let message = Message(content: response, sentByUser: false)
                self?.addMessageToCurrentConversation(message)
                self?.speechRecordingBlocked = false
            }
        }
    }
    
    private func addMessageToCurrentConversation(_ message: Message) {
        currentConversation.messages.append(message)
    }
    
    func uploadImage() {
        
    }
}
