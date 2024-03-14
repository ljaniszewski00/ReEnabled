import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Inject private var openAIManager: OpenAIManaging
    
    @Published var currentConversation: Conversation = Conversation(messages: [])
    @Published var conversations: [Conversation] = [Conversation]()
    
    @Published var speechRecordingBlocked: Bool = false
    @Published var showPreviousConversations: Bool = false
    
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
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
        
        generateResponse(for: transcript)
    }
    
    private func generateResponse(for query: String) {
        speechRecordingBlocked = true
        openAIManager.generateResponse(for: query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.speechRecordingBlocked = false
            } receiveValue: { [weak self] response in
                guard let response = response else {
                    return
                }
                
                let message = Message(content: response, sentByUser: false)
                self?.addMessageToCurrentConversation(message)
            }
            .store(in: &cancelBag)
    }
    
    private func addMessageToCurrentConversation(_ message: Message) {
        currentConversation.messages.append(message)
    }
    
    func uploadImage() {
        
    }
}
