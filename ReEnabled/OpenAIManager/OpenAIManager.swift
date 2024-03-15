import Combine
import Foundation
import OpenAI
import UIKit

class OpenAIManager: ObservableObject, OpenAIManaging {
    private var openAI: OpenAI?
    private var apiToken: String?
    
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()
    
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
        self.apiToken = apiToken
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
    
    func generateResponse(for prompt: String, with image: UIImage) -> AnyPublisher<String?, Never> {
        guard let openAI = openAI else {
            return Just(nil)
                .eraseToAnyPublisher()
        }
        
        prepareRequest(for: prompt, with: image)
        
        return Just(nil)
            .eraseToAnyPublisher()
    }
    
    private func prepareRequest(for prompt: String, with image: UIImage) {
        guard let apiToken = apiToken,
              let imageBase64String: String = image.base64,
              let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return
        }
        
        let body: [String: Any] = [
            "model": "gpt-4-vision-preview",
            "messages": [
                "role": "user",
                "content": [
                    [
                        "type": "text",
                        "text": prompt,
                    ],
                    [
                        "type": "image_url",
                        "image_url": [
                            "url": "data:image/jpeg;base64,\(imageBase64String)"
                        ]
                    ]
                ]
            ],
            "max_tokens": 300
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiToken)"
        ]
        
        print("BODY BEFORE JSON")
        print("BODY KEYS")
        print(body.keys)
        print("BODY VALUES")
        print(body.values)
        print()
        
        print("HEADER")
        print(request.allHTTPHeaderFields)
        print()
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        print("BODY AFTER JSON")
        print(request.httpBody)
        print()
        
        let cancellableDataTask = URLSession.shared
            .dataTaskPublisher(for: request)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                print("RESPONSE BEFORE JSON")
                print(response)
                print()
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as? [String: Any] else {
                        return
                    }
                    
                    print("RESPONSE AFTER JSON")
                    print(json)
                    print()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        
        cancelBag.insert(cancellableDataTask)
    }
}

protocol OpenAIManaging {
    func generateResponse(for prompt: String) -> AnyPublisher<String?, Never>
    func generateResponse(for prompt: String, with image: UIImage) -> AnyPublisher<String?, Never>
}
