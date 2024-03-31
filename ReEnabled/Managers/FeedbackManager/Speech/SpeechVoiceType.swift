import RealmSwift

enum SpeechVoiceType: String, PersistableEnum {
    case female = "Female"
    case male = "Male"    
}

extension SpeechVoiceType: CaseIterable {
    static var allCases: [SpeechVoiceType] {
        [
            .female,
            .male
        ]
    }
}
