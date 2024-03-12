import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @StateObject private var searchViewModel: SearchViewModel = SearchViewModel()
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = VoiceRecordingManager()
    
    var body: some View {
        VStack(spacing: Views.Constants.mainVStackSpacing) {
            Views.NavigationBar()
                .environmentObject(searchViewModel)
            
            ScrollView(.vertical) {
                VStack {
                    ForEach(searchViewModel.currentConversation.messages, id: \.id) { message in
                        Views.MessageCell(message: message)
                            .padding(.bottom, Views.Constants.messageCellBottomPadding)
                    }
                }
                .padding()
                .padding(.bottom)
            }
            .environmentObject(tabBarStateManager)
            .environmentObject(searchViewModel)
        }
        .padding(.bottom, tabBarStateManager.screenBottomPaddingForViews)
        .onLongPressGesture {
            manageTalking()
        }
    }
    
    private func manageTalking() {
        if voiceRecordingManager.isRecording {
            stopTalking()
        } else {
            startTalking()
        }
    }
    
    private func startTalking() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        voiceRecordingManager.startTranscribing()
    }
    
    private func stopTalking() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        voiceRecordingManager.stopTranscribing()
        searchViewModel.addNewMessageWith(transcript: voiceRecordingManager.transcript)
    }
}

#Preview {
    let tabBarStateManager: TabBarStateManager = TabBarStateManager()
    
    return SearchView()
        .environmentObject(tabBarStateManager)
}

private extension Views {
    struct Constants {
        static let mainVStackSpacing: CGFloat = 0
        static let messageCellVStackSpacing: CGFloat = 8
        static let messageCellSentByUserLabel: String = "You"
        static let messageCellNotSentByUserLabel: String = "Device"
        static let messageCellBottomPadding: CGFloat = 15
        
        static let navigationTitle: String = "Search"
        static let toolbarButtonPhotoImageName: String = "photo"
        static let toolbarButtonMessageHistoryImageName: String = "list.dash"
    }
    
    struct NavigationBar: View {
        @EnvironmentObject private var searchViewModel: SearchViewModel
        
        var body: some View {
            CustomNavigationBar(title: Views.Constants.navigationTitle,
                                leadingItem: {
                Button {
                    searchViewModel.showPreviousConversations = true
                } label: {
                    Image(systemName: Views.Constants.toolbarButtonMessageHistoryImageName)
                        .resizable()
                        .scaledToFill()
                }
            },
                                secondLeadingItem: {
                Text("")
            },
                                trailingItem: {
                Text("")
            },
                                secondTrailingItem: {
                Button {
                    searchViewModel.uploadImage()
                } label: {
                    Image(systemName: Views.Constants.toolbarButtonPhotoImageName)
                        .resizable()
                        .scaledToFill()
                }
            })
        }
    }
    
    struct MessageCell: View {
        let message: Message
        
        var body: some View {
            VStack(alignment: .leading, 
                   spacing: Views.Constants.messageCellVStackSpacing) {
                HStack {
                    Group {
                        if message.sentByUser {
                            Text(Views.Constants.messageCellSentByUserLabel)
                        } else {
                            Text(Views.Constants.messageCellNotSentByUserLabel)
                        }
                    }
                    .bold()
                    
                    Text(" | ")
                    Text(message.hourSent)
                        .foregroundStyle(.tertiary)
                }
                
                
                Text(message.content)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
            }
        }
    }
}
