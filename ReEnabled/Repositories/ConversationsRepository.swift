import Combine
import Foundation

final class ConversationsRepository: ConversationsRepositoryProtocol {
    @Inject private var realmManager: RealmManaging
    
    // MARK: - DEBUG
//    init() {
//        realmManager.deleteAllData()
//    }
    
    func getConversations() -> AnyPublisher<[Conversation], Error> {
        realmManager.objects(ofType: ConversationObject.self)
            .map { $0.map({
                print()
                print($0)
                print()
                print($0.toModel)
                return $0.toModel }) }
            .eraseToAnyPublisher()
    }
    
    func updateConversation(_ conversation: Conversation) {
        realmManager.updateObjects(with: [conversation.toObject])
    }
    
    func deleteConversation(_ conversation: Conversation) {
        let predicate: NSPredicate = NSPredicate(format: "id == %@", conversation.id)
        realmManager.delete(dataOfType: ConversationObject.self, with: predicate)
    }
}

protocol ConversationsRepositoryProtocol {
    func getConversations() -> AnyPublisher<[Conversation], Error>
    func updateConversation(_ conversation: Conversation)
    func deleteConversation(_ conversation: Conversation)
}
