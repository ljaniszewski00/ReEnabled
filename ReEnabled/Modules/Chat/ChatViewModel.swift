import Combine
import Foundation
import RealmSwift
import SwiftUI

final class ChatViewModel: ObservableObject {
    @Inject private var openAIManager: OpenAIManaging
    @Inject private var conversationsRepository: ConversationsRepositoryProtocol
    
    private var feedbackManager: FeedbackManager = .shared
    
    @Published var currentConversation: Conversation?
    @Published var conversations: [Conversation] = []
    
    @Published var speechRecordingBlocked: Bool = false
    @Published var showCamera: Bool = false
    
    @Published var selectedImage: UIImage?
    
    var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func getConversations(from conversationsObjects: Results<ConversationObject>) {
        let fetchedConversations: [Conversation] = conversationsRepository.getConversations(from: conversationsObjects)
        
        guard !fetchedConversations.isEmpty else {
            self.addNewConversation()
            return
        }
        
        self.conversations = fetchedConversations
        self.sortConversations()
        self.currentConversation = self.conversations.last
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
                        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.chat(.conversationDeleted))
                    }
                    
                    self.addNewConversation()
                }
                .store(in: &cancelBag)
        }
    }
    
    func deleteAllConversations() -> AnyPublisher<Void, Never> {
        conversationsRepository.deleteAllConversations()
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }
    
    func readConversation() {
        guard let currentConversation = currentConversation else {
            return
        }
        
        if !currentConversation.transcriptText.isEmpty {
            feedbackManager.generateSpeechFeedback(with: currentConversation.transcriptText)
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
    
    func addNewMessageWithImageOnVoiceCommand(messageContent: String = "Describe the photo") {
        selectPhoto()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self,
                  let selectedImage = selectedImage else {
                return
            }
            
            let message: Message = Message(content: messageContent, imageContent: selectedImage, sentByUser: true)
            addMessageToCurrentConversation(message)
            
            generateImageResponse(for: messageContent)
        }
    }
    
    private func generateResponse(for query: String) {
        speechRecordingBlocked = true
        openAIManager.generateResponse(for: query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.speechRecordingBlocked = false
            } receiveValue: { [weak self] response in
                guard let self = self,
                      let response = response else {
                    return
                }
                
                let message = Message(content: response, sentByUser: false)
                self.feedbackManager.generateSpeechFeedback(with: SpeechFeedback.chat(.thisIsTheResponse),
                                                            and: message.content)
                self.addMessageToCurrentConversation(message)
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
                self.feedbackManager.generateSpeechFeedback(with: SpeechFeedback.chat(.thisIsTheResponse),
                                                            and: message.content)
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
