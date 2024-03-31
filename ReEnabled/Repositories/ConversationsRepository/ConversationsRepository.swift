import Combine
import Foundation

final class ConversationsRepository: ConversationsRepositoryProtocol {
    @Inject private var realmManager: RealmManaging
    
    private let predicateKeyFilteringFormat: String = "id == %@"
    
    // MARK: - DEBUG
//    init() {
//        realmManager.deleteAllData()
//    }
    
    func getConversations() -> AnyPublisher<[Conversation], Error> {
        realmManager.objects(ofType: ConversationObject.self)
            .map { $0.map({ $0.toModel }) }
            .eraseToAnyPublisher()
    }
    
    func updateConversation(_ conversation: Conversation) {
        realmManager.updateObjects(with: [conversation.toObject])
    }
    
    func deleteConversation(_ conversation: Conversation) -> AnyPublisher<Void, Error> {
        let predicate: NSPredicate = NSPredicate(format: predicateKeyFilteringFormat, conversation.id)
        return realmManager.delete(dataOfType: ConversationObject.self, forPredicate: predicate)
            .eraseToAnyPublisher()
    }
    
    func deleteAllConversations() -> AnyPublisher<Void, Error> {
        return realmManager.delete(dataOfType: ConversationObject.self, forPredicate: nil)
            .eraseToAnyPublisher()
    }
}

protocol ConversationsRepositoryProtocol {
    func getConversations() -> AnyPublisher<[Conversation], Error>
    func updateConversation(_ conversation: Conversation)
    func deleteConversation(_ conversation: Conversation) -> AnyPublisher<Void, Error>
    func deleteAllConversations() -> AnyPublisher<Void, Error>
}
