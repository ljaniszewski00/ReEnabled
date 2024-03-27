import Combine
import Foundation
import SwiftUI

final class ChatViewModel: ObservableObject {
    @Inject private var openAIManager: OpenAIManaging
    @Inject private var conversationsRepository: ConversationsRepositoryProtocol
    
    @Published var currentConversation: Conversation?
    @Published var conversations: [Conversation] = []
    
    @Published var speechRecordingBlocked: Bool = false
    @Published var showCamera: Bool = false
    
    @Published var selectedImage: UIImage?
    
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        fetchConversations()
    }
    
    func fetchConversations() {
        conversationsRepository.getConversations()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] fetchedConversations in
                guard let self = self,
                      !fetchedConversations.isEmpty else {
                    self?.addNewConversation()
                    return
                }
                
                self.conversations = fetchedConversations
                self.sortConversations()
                self.currentConversation = self.conversations.last
            }
            .store(in: &cancelBag)
    }
    
    func sortConversations() {
        conversations.sort {
            guard let firstStartDate = $0.startDate,
                  let secondStartDate = $1.startDate else {
                return true
            }
            
            return firstStartDate < secondStartDate
        }
    }
    
    func addNewConversation() {
        currentConversation = Conversation(messages: [])
    }
    
    func changeCurrentConversationToPrevious() {
        guard let currentConversation = currentConversation,
              let previousConversation = conversations.before(currentConversation) else {
            addNewConversation()
            return
        }
        
        self.currentConversation = previousConversation
    }
    
    func changeCurrentConversationToNext() {
        guard let currentConversation = currentConversation,
              let nextConversation = conversations.after(currentConversation) else {
            addNewConversation()
            return
        }
        
        self.currentConversation = nextConversation
    }
    
    func saveCurrentConversation() {
        guard let currentConversation = currentConversation else {
            return
        }
        
        if !currentConversation.messages.isEmpty {
            conversationsRepository.updateConversation(currentConversation)
        }
    }
    
    func deleteCurrentConversation() {
        guard let currentConversation = currentConversation else {
            return
        }
        
        if !currentConversation.messages.isEmpty {
            conversationsRepository.deleteConversation(currentConversation)
                .sink { _ in
                } receiveValue: { [weak self] _ in
                    guard let self = self else {
                        return
                    }
                    
                    if let currentConversationIndex = self.conversations.firstIndex(of: currentConversation) {
                        self.conversations.remove(at: currentConversationIndex)
                    }
                    
                    self.addNewConversation()
                }
                .store(in: &cancelBag)
        }
    }
    
    func selectPhoto() {
        showCamera = true
    }
    
    func manageAddingMessageWith(transcript: String) {
        if selectedImage != nil {
            addNewMessageWithImage(transcript: transcript)
        } else {
            addNewMessageWith(transcript: transcript)
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
    
    func addNewMessageWithImage(transcript: String) {
        guard !transcript.isEmpty,
              let selectedImage = selectedImage else {
            return
        }
        
        let message: Message = Message(content: transcript, imageContent: selectedImage, sentByUser: true)
        addMessageToCurrentConversation(message)
        
        generateImageResponse(for: transcript)
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
    
    private func generateImageResponse(for query: String) {
        guard let selectedImage = selectedImage else {
            return
        }
        
        speechRecordingBlocked = true
        
        openAIManager.generateImageResponse(for: query, with: selectedImage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.speechRecordingBlocked = false
            } receiveValue: { [weak self] response in
                guard let self = self,
                      let response = response else {
                    return
                }
                
                let message = Message(content: response, sentByUser: false)
                self.addMessageToCurrentConversation(message)
                self.selectedImage = nil
            }
            .store(in: &cancelBag)
    }
    
    private func addMessageToCurrentConversation(_ message: Message) {
        guard currentConversation != nil else {
            return
        }
        
        currentConversation!.messages.append(message)
        saveCurrentConversation()
    }
}
