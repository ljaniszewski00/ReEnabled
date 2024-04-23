import SwiftUI

struct ContentView: View {
    @AppStorage(AppStorageKeys.shouldDisplayOnboarding) var shouldDisplayOnboarding: Bool = true
    
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var voiceRequestor: VoiceRequestor = .shared
    
    @StateObject private var onboardingViewModel: OnboardingViewModel = OnboardingViewModel()
    
    private var selection: String {
        tabBarStateManager.tabSelection.title
    }
    
    var body: some View {
        Group {
            if shouldDisplayOnboarding {
                OnboardingView()
                    .environmentObject(onboardingViewModel)
                    .transition(.slide)
                    .animation(.default)
                    .zIndex(1)
            } else {
                CustomTabBarContainerView(selection: $tabBarStateManager.tabSelection) {
                    MainCameraRecognizerView()
                        .tabBarItem(tab: .camera,
                                    selection: $tabBarStateManager.tabSelection)
                    
                    ChatView()
                        .tabBarItem(tab: .chat,
                                    selection: $tabBarStateManager.tabSelection)
                    
                    SettingsView()
                        .tabBarItem(tab: .settings,
                                    selection: $tabBarStateManager.tabSelection)
                }
                .onChange(of: tabBarStateManager.tabSelection) { _, newTab in
                    if newTab != .camera {
                        feedbackManager.generateSpeechFeedback(with: newTab.title)
                    }
                }
                .onChange(of: voiceRecordingManager.isRecording) { _, isRecording in
                    tabBarStateManager.shouldAnimateChatTabIcon = isRecording
                }
                .onChange(of: voiceRecordingManager.transcript) { _, newTranscript in
                    voiceRequestor.getVoiceRequest(from: newTranscript)
                }
                .onChange(of: voiceRequestor.selectedVoiceRequest) { _, voiceRequest in
                    guard voiceRequest != VoiceRequest.empty else {
                        return
                    }
                    
                    switch voiceRequest {
                    case .other(.changeTabToCamera):
                        tabBarStateManager.changeTabSelectionTo(.camera)
                    case .other(.changeTabToChat):
                        tabBarStateManager.changeTabSelectionTo(.chat)
                    case .other(.changeTabToSettings):
                        tabBarStateManager.changeTabSelectionTo(.settings)
                    case .other(.displayOnboarding):
                        shouldDisplayOnboarding = true
                    default:
                        return
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ContentView()
}

private extension Views {
    struct Constants {
        static let voiceCommandPreviewViewOpacity: CGFloat = 0.7
        static let conditionalContentBlurRadius: CGFloat = 2.0
        
        static let voiceCommandPreviewViewImageName: String = "waveform.badge.mic"
        static let voiceCommandPreviewViewImageSize: CGFloat = 120
        static let voiceCommandPreviewViewBackgroundCornerRadius: CGFloat = 10
        static let voiceCommandPreviewViewFrameSize: CGFloat = 300
    }
}
