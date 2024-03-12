import Foundation

struct Conversation {
    let id: String = UUID().uuidString
    let messages: [Message]
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
