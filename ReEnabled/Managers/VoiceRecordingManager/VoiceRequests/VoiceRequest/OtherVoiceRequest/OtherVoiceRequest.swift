enum OtherVoiceRequest {
    case changeTabToCamera
    case recognizeObjects
    case scanDocument
    case detectColor
    case detectLight
    case changeTabToChat
    case sendNewMessage
    case changeTabToSettings
    case remindVoiceCommands
    case remindGestures
    case displayOnboarding
}

extension OtherVoiceRequest {
    var rawValue: String {
        switch self {
        case .changeTabToCamera:
            return VoiceRequestText.otherVoiceRequestChangeTabToCamera.rawValue.localized()
        case .recognizeObjects:
            return VoiceRequestText.otherVoiceRequestRecognizeObjects.rawValue.localized()
        case .scanDocument:
            return VoiceRequestText.otherVoiceRequestScanDocument.rawValue.localized()
        case .detectColor:
            return VoiceRequestText.otherVoiceRequestDetectColor.rawValue.localized()
        case .detectLight:
            return VoiceRequestText.otherVoiceRequestDetectLight.rawValue.localized()
        case .changeTabToChat:
            return VoiceRequestText.otherVoiceRequestChangeTabToChat.rawValue.localized()
        case .sendNewMessage:
            return VoiceRequestText.otherVoiceRequestSendNewMessage.rawValue.localized()
        case .changeTabToSettings:
            return VoiceRequestText.otherVoiceRequestChangeTabToSettings.rawValue.localized()
        case .remindVoiceCommands:
            return VoiceRequestText.otherVoiceRequestRemindVoiceCommands.rawValue.localized()
        case .remindGestures:
            return VoiceRequestText.otherVoiceRequestRemindGestures.rawValue.localized()
        case .displayOnboarding:
            return VoiceRequestText.otherVoiceRequestDisplayOnboarding.rawValue.localized()
        }
    }
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
