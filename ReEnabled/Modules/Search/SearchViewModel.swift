import Combine
import Foundation
import SwiftUI

final class SearchViewModel: ObservableObject {
    @Inject private var openAIManager: OpenAIManaging
    
    @Published var currentConversation: Conversation = Conversation(messages: [])
    @Published var conversations: [Conversation] = [Conversation]()
    
    @Published var speechRecordingBlocked: Bool = false
    @Published var showPreviousConversations: Bool = false
    @Published var showCamera: Bool = false
    
    @Published var selectedImage: UIImage?
    
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        fetchConversations()
    }
    
    func fetchConversations() {
        guard let newestConversation = conversations.sorted(by: {
            guard let firstStartDate = $0.startDate,
                  let secondStartDate = $1.startDate else {
                return true
            }
            
            return firstStartDate < secondStartDate
        }).first else {
            currentConversation = Conversation(messages: [])
            modelContext.insert(currentConversation)
            return
        }
        
        currentConversation = newestConversation
    }
    
    func saveCurrentConversation() {
        if !currentConversation.messages.isEmpty {
            modelContext.insert(currentConversation)
        }
    }
    
    func deleteCurrentConversation() {
        if conversations.contains(currentConversation) {
            modelContext.delete(currentConversation)
        }
        
        fetchConversations()
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
        
//        generateImageResponse(for: transcript)
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
        speechRecordingBlocked = true
        
        guard let selectedImage = selectedImage else {
            return
        }
        
        openAIManager.generateImageResponse(for: query, with: selectedImage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.speechRecordingBlocked = false
                self?.selectedImage = nil
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
        saveCurrentConversation()
    }
}
