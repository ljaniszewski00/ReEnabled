import Foundation

enum OpenAIEndpoints {
    case chatCompletions
    case visionChatCompletions
}

extension OpenAIEndpoints: APIEndpoint {
    var baseURL: URL {
        URL(string: "https://api.openai.com/v1")!
    }
    
    var path: String {
        switch self {
        case .chatCompletions:
            return "/chat/completions"
        case .visionChatCompletions:
            return "/chat/completions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .chatCompletions:
            return .post
        case .visionChatCompletions:
            return .post
        }
    }
    
    var headers: [String : String]? {
        guard let path = Bundle.main.path(forResource: "OpenAIPropertyList", ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let plistDict = try? PropertyListSerialization.propertyList(from: data,
                                                                          options: .mutableContainers,
                                                                          format: nil) as? [String:String],
              let apiToken = plistDict.values.first else {
            return nil
        }
        
        let header: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiToken)"
        ]
        
        switch self {
        case .chatCompletions:
            return header
        case .visionChatCompletions:
            return header
        }
    }
}
