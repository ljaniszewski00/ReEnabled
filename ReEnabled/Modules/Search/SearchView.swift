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
                    
                    if searchViewModel.speechRecordingBlocked {
                        ProgressView()
                    }
                }
                .padding()
                .padding(.bottom)
            }
            .padding(.bottom, Views.Constants.scrollViewBottomPadding)
        }
        .onTapGesture {}
        .onLongPressGesture {
            if !searchViewModel.speechRecordingBlocked {
                voiceRecordingManager.manageTalking()
            }
        }
        .onChange(of: voiceRecordingManager.transcript) { transcript in
            searchViewModel.addNewMessageWith(transcript: transcript)
//            searchViewModel.addNewMessageWithImage(transcript: transcript)
        }
        .fullScreenCover(isPresented: $searchViewModel.showCamera) {
            AccessCameraView(selectedImage: $searchViewModel.selectedImage)
        }
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
        
        static let messageCellImageClipShapeCornerRadius: CGFloat = 5
        static let messageCellImageTopPadding: CGFloat = 15
        static let messageCellImageBottomPadding: CGFloat = 10
        
        static let scrollViewBottomPadding: CGFloat = 35
        
        static let navigationTitle: String = "Search"
        static let toolbarButtonMessageHistoryImageName: String = "list.dash"
        static let toolbarButtonMessageSaveImageName: String = "square.and.arrow.down.fill"
        static let toolbarButtonPhotoImageName: String = "photo"
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
                Button {
                    searchViewModel.saveCurrentConversation()
                } label: {
                    Image(systemName: Views.Constants.toolbarButtonMessageSaveImageName)
                        .resizable()
                        .scaledToFill()
                }
            },
                                trailingItem: {
                Text("")
            },
                                secondTrailingItem: {
                Button {
                    searchViewModel.showCamera = true
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
                    
                    Divider()
                    
                    Text(message.hourSent)
                        .foregroundStyle(.tertiary)
                }
                
                Text(message.content)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let imageContent = message.imageContent {
                    HStack {
                        Image(uiImage: imageContent)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius:
                                        Views.Constants.messageCellImageClipShapeCornerRadius
                                )
                            )
                            .padding(.top, Views.Constants.messageCellImageTopPadding)
                            .padding(.bottom, Views.Constants.messageCellImageBottomPadding)
                        
                        Spacer()
                    }
                }
                
                Divider()
            }
        }
    }
}
