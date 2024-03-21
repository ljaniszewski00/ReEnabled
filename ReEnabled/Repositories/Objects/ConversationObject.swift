import RealmSwift

class ConversationObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var messages: List<MessageObject>
}
