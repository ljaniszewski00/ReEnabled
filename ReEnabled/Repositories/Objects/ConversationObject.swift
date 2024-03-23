import Foundation
import RealmSwift

class ConversationObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var messages: List<MessageObject>
}

extension ConversationObject {
    var toModel: Conversation {
        Conversation(id: id, messages: Array(_immutableCocoaArray: messages))
    }
}
