enum SpeechVoiceType: String {
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
