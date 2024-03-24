import Foundation
import RealmSwift

class ConversationObject: Object, ObjectKeyIdentifiable, RealmObjectProtocol {
    @Persisted(primaryKey: true) var id: String
    @Persisted var messages: List<MessageObject>
}

extension ConversationObject {
    enum ConversationObjectKeys: String {
        case id
        case messages
    }
}

extension ConversationObject {
    var toModel: Conversation {
        let messagesArray: [Message] = messages.map {
            Message(id: $0.id,
                    content: $0.content,
                    imageContent: $0.imageContentData?.uiImageFromBase64,
                    dateSent: $0.dateSent,
                    sentByUser: $0.sentByUser)
        }
        
        return Conversation(id: id, messages: messagesArray)
    }
}
