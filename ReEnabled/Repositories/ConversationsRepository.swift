import Combine

final class ConversationsRepository: ConversationsRepositoryProtocol {
    @Inject private var realmManager: RealmManaging
    
    func getConversations() -> AnyPublisher<[Conversation], Error> {
        realmManager.objects(ofType: ConversationObject.self)
            .map { $0.map({ $0.toModel }) }
            .eraseToAnyPublisher()
    }
    
    func updateConversation(_ conversation: Conversation) -> AnyPublisher<Void, Error> {
        realmManager.updateObjects(with: [conversation.toObject])
    }
    
    func deleteConversation(_ conversation: Conversation) -> AnyPublisher<Void, Error> {
        realmManager.delete(data: [conversation.toObject])
    }
}

protocol ConversationsRepositoryProtocol {
    func getConversations() -> AnyPublisher<[Conversation], Error>
    func updateConversation(_ conversation: Conversation) -> AnyPublisher<Void, Error>
    func deleteConversation(_ conversation: Conversation) -> AnyPublisher<Void, Error>
}
