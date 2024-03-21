import RealmSwift

class MessageObject: EmbeddedObject {
    @Persisted(primaryKey: true) var id: String
    @Persisted var content: String
    @Persisted var imageContentData: String?
    @Persisted var dateSent: String
    @Persisted var sentByUser: Bool
}
