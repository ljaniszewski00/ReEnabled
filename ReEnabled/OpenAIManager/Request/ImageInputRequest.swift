import Foundation

struct ImageInputRequest {
    private var request: URLRequest
    
    init(url: URL, apiToken: String, imageBase64String: String) {
        self.request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiToken)"
        ]
    }
    
    struct ImageInputRequestBody: Codable {
        let model: String = "gpt-4-vision-preview"
        let messages: [Message]
        let maxTokens: Int = 300

        enum CodingKeys: String, CodingKey {
            case model, messages
            case maxTokens = "max_tokens"
        }
        
        struct Message: Codable {
            let role: String
            let content: [Content]
        }

        struct Content: Codable {
            let type: String
            let text: String?
        }
    }
}
