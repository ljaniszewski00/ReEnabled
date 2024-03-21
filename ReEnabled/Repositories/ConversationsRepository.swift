import RealmSwift

final class ConversationsRepository: ConversationsRepositoryProtocol {
    @Inject private var realmManager: RealmManaging
}

protocol ConversationsRepositoryProtocol {
    
}
