enum OtherSpeechFeedback {
    case currentTab
    case tabChangedTo
    case youCanUseFollowingVoiceCommands
    case youCanUseFollowingGestures
    case voiceCommandWasNotRecognized
    case whatYouWantMeToDo
}

extension OtherSpeechFeedback {
    var rawValue: String {
        switch self {
        case .currentTab:
            return SpeechFeedbackText.otherSpeechFeedbackCurrentTab.rawValue.localized()
        case .tabChangedTo:
            return SpeechFeedbackText.otherSpeechFeedbackTabChangedTo.rawValue.localized()
        case .youCanUseFollowingVoiceCommands:
            return SpeechFeedbackText.otherSpeechFeedbackYouCanUseFollowingVoiceCommands.rawValue.localized()
        case .youCanUseFollowingGestures:
            return SpeechFeedbackText.otherSpeechFeedbackYouCanUseFollowingGestures.rawValue.localized()
        case .voiceCommandWasNotRecognized:
            return SpeechFeedbackText.otherSpeechFeedbackVoiceCommandWasNotRecognized.rawValue.localized()
        case .whatYouWantMeToDo:
            return SpeechFeedbackText.otherSpeechFeedbackWhatYouWantMeToDo.rawValue.localized()
        }
    }
}
