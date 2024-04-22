enum OtherVoiceRequest: String {
    case changeTabToCamera = "Change tab to camera"
    case recognizeObjects = "Recognize cbjects"
    case scanDocument = "Scan document"
    case detectColor = "Detect color"
    case detectLight = "Detect light"
    
    case changeTabToChat = "Change tab to chat"
    case sendNewMessage = "Send new message"
    
    case changeTabToSettings = "Change tab to settings"
    
    case remindVoiceCommands = "Remind voice commands"
    case remindGestures = "Remind gestures"
    
    case displayOnboarding = "Display onboarding"
}

extension OtherVoiceRequest: CaseIterable {
    static let allCases: [VoiceRequest] = [
        .other(.changeTabToCamera),
        .other(.recognizeObjects),
        .other(.scanDocument),
        .other(.detectColor),
        .other(.detectLight),
        .other(.changeTabToChat),
        .other(.sendNewMessage),
        .other(.changeTabToSettings),
        .other(.remindVoiceCommands),
        .other(.remindGestures),
        .other(.displayOnboarding)
    ]
    
    static let casesForOtherTabs: [VoiceRequest] = [
        .other(.changeTabToCamera),
        .other(.changeTabToChat),
        .other(.changeTabToSettings),
        .other(.remindVoiceCommands),
        .other(.remindGestures)
    ]
}
