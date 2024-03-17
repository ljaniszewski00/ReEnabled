import Foundation

struct OpenAIMessageContent: Identifiable, Codable {
    let id = UUID()
    let type: OpenAIMessageContentType
    var text: String?
    var imageUrl: ImgUrl?
    
    enum CodingKeys: String, CodingKey {
        case type, text
        case imageUrl = "image_url"
    }

    init(type: OpenAIMessageContentType, value: String? = nil) {
        self.type = type
        self.text = nil
        self.imageUrl = nil
    
        if type == .text {
            self.text = value
        } else {
            guard let value = value else {
                return
            }
            
            self.imageUrl = ImgUrl(url: "data:image/jpeg;base64,\(value)")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        if type == .text {
            try container.encode(text, forKey: .text)
        } else {
            try container.encode(imageUrl, forKey: .imageUrl)
        }
    }
    
    struct ImgUrl: Codable {
        let url: String
    }
}
