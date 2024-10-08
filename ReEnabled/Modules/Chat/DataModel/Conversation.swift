import Foundation
import RealmSwift

struct Conversation: Equatable {
    var id: String = UUID().uuidString
    var messages: [Message]
    
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        lhs.id == rhs.id
    }
}

extension Conversation {
    var startDate: Date? {
        messages
            .map { $0.dateSent }
            .min()
    }
    
    var title: String? {
        messages
            .sorted { $0.dateSent < $1.dateSent }
            .first
            .map { $0.content }
    }
    
    var messagesCount: Int {
        messages.count
    }
    
    var transcriptText: String {
        var text: String = ""
        
        for message in self.messages {
            text += "\n"
            text += message.sentByUser ? ChatTabText.chatYou.rawValue.localized() : ChatTabText.chatDevice.rawValue.localized()
            text += " "
            text += message.hourSent.description
            text += " "
            text += message.content
            text += "\n"
            text += "\n"
        }
        
        return text
    }
}

extension Conversation {
    static let mockData: Conversation = Conversation(
        messages: [
            Message.mockData,
            Message.mockData2,
            Message.mockData3,
            Message.mockData4,
            Message.mockData5,
            Message.mockData6,
        ]
    )
    
    static let mockData2: Conversation = Conversation(
        messages: [
            Message.mockData,
            Message.mockData2,
            Message.mockData3,
            Message.mockData4,
            Message.mockData5,
            Message.mockData6,
        ]
    )
}

extension Conversation {
    var toObject: ConversationObject {
        let messagesObjectsArray = messages.map { $0.toObject }
        let messagesList: List<MessageObject> = List<MessageObject>()
        messagesList.append(objectsIn:
            messagesObjectsArray
        )
        
        return ConversationObject(value:
            [
                ConversationObject.ConversationObjectKeys.id.rawValue: id,
                ConversationObject.ConversationObjectKeys.messages.rawValue: messagesList
            ]
        )
    }
}
