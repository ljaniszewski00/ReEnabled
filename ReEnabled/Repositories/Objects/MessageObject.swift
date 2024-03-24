import RealmSwift
import UIKit

class MessageObject: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var id: String
    @Persisted var content: String
    @Persisted var imageContentData: String?
    @Persisted var dateSent: Date
    @Persisted var sentByUser: Bool
}

extension MessageObject {
    var toModel: Message {
        Message(id: id,
                content: content,
                imageContent: imageContentData?.uiImageFromBase64,
                dateSent: dateSent,
                sentByUser: sentByUser)
    }
}
