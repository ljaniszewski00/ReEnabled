enum GestureAction {
    case camera(CameraGestureAction)
    case chat(ChatGestureAction)
    case settings(SettingsGestureAction)
    case onboarding(OnboardingGestureAction)
    case other(OtherGestureAction)
}
