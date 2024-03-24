import Foundation
import UIKit

struct Message: Equatable {
    var id: String = UUID().uuidString
    let content: String
    var imageContent: UIImage? = nil
    var dateSent: Date = Date()
    let sentByUser: Bool
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}

extension Message {
    var hourSent: String {
        let dateFormatter: DateFormatter = .hoursMinutesDateFormatter
        return dateFormatter.string(from: dateSent)
    }
}

extension Message {
    static let mockData: Message = Message(
        content: "Lorem ipsum dolor sit amet",
        dateSent: Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date(),
        sentByUser: true
    )
    
    static let mockData2: Message = Message(
        content: "consectetur adipiscing elit",
        dateSent: Calendar.current.date(byAdding: .hour, value: -4, to: Date()) ?? Date(),
        sentByUser: false
    )
    
    static let mockData3: Message = Message(
        content: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
        dateSent: Calendar.current.date(byAdding: .hour, value: -3, to: Date()) ?? Date(),
        sentByUser: true
    )
    
    static let mockData4: Message = Message(
        content: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
        dateSent: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
        sentByUser: false
    )
    
    static let mockData5: Message = Message(
        content: "Excepteur sint occaecat cupidatat non proident",
        dateSent: Calendar.current.date(byAdding: .hour, value: -1, to: Date()) ?? Date(),
        sentByUser: true
    )
    
    static let mockData6: Message = Message(
        content: "sunt in culpa qui officia deserunt mollit anim id est laborum.",
        dateSent: Date(),
        sentByUser: false
    )
}

extension Message {
    var toObject: MessageObject {
        MessageObject(value:
            [
                "id": id,
                "content": content,
                "imageContent": imageContent?.base64?.utf8,
                "dateSent": dateSent,
                "sentByUser": sentByUser
            ]
        )
    }
}

