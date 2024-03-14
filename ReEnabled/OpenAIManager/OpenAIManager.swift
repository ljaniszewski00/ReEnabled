import Combine
import Foundation
import OpenAI
import UIKit

class OpenAIManager: ObservableObject, OpenAIManaging {
    private var openAI: OpenAI?
    
    init() {
        initializeOpenAI()
    }
    
    private func initializeOpenAI() {
        guard let path = Bundle.main.path(forResource: "OpenAIPropertyList", ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let plistDict = try? PropertyListSerialization.propertyList(from: data,
                                                                          options: .mutableContainers,
                                                                          format: nil) as? [String:String],
              let apiToken = plistDict.values.first else {
            return
        }
        
        self.openAI = OpenAI(apiToken: apiToken)
    }
    
    func generateResponse(for prompt: String) -> AnyPublisher<String?, Never> {
        guard let openAI = openAI else {
            return Just(nil)
                .eraseToAnyPublisher()
        }
        
        let message: Chat = Chat(role: .user, content: prompt)
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [message])
        
        return openAI
            .chats(query: query)
            .map({ chatResult in
                chatResult.choices.first?.message.content
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

protocol OpenAIManaging {
    func generateResponse(for prompt: String) -> AnyPublisher<String?, Never>
}
