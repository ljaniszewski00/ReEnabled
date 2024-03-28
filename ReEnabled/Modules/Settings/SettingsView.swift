import SwiftUI

struct SettingsView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Views.navigationBar
                
                List {
                    
                }
                .listStyle(GroupedListStyle())
            }
        }
    }
}

#Preview {
    SettingsView()
}

private extension Views {
    struct Constants {
        static let navigationTitle: String = "Settings"
    }
    
    static var navigationBar: some View {
        CustomNavigationBar(title: Views.Constants.navigationTitle,
                            leadingItem: {
            Text("")
        },
                            secondLeadingItem: {
            Text("")
        },
                            trailingItem: {
            Text("")
        },
                            secondTrailingItem: {
            Text("")
        })
    }
}
