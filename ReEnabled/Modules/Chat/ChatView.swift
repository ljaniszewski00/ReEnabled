import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @StateObject private var chatViewModel: ChatViewModel = ChatViewModel()
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = VoiceRecordingManager()
    
    var body: some View {
        VStack(spacing: Views.Constants.mainVStackSpacing) {
            Views.NavigationBar()
                .environmentObject(chatViewModel)
            
            Group {
                ScrollView(.vertical) {
                    VStack {
                        if let currentConversation = chatViewModel.currentConversation {
                            ForEach(currentConversation.messages, id: \.id) { message in
                                Views.MessageCell(message: message)
                                    .padding(.bottom, Views.Constants.messageCellBottomPadding)
                            }
                        }
                        
                        if chatViewModel.speechRecordingBlocked {
                            ProgressView()
                        }
                    }
                    .padding()
                    .padding(.bottom)
                }
                
                if let image = chatViewModel.selectedImage {
                    VStack(spacing: 10) {
                        LabelledDivider(label: "To be send")
                        
                        HStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 40)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius:
                                            Views.Constants.messageCellImageClipShapeCornerRadius
                                    )
                                )
                                .padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                    .padding(.bottom, Views.Constants.scrollViewBottomPadding)
                }
            }
            .padding(.bottom, Views.Constants.scrollViewBottomPadding)
        }
        .addGesturesActions(onTap: {
//            if !chatViewModel.speechRecordingBlocked {
//                voiceRecordingManager.manageTalking()
//            }
            chatViewModel.addNewMessageWithImage(transcript: Message.mockData6.content)
        }, onDoubleTap: {
            
        }, onLongPress: {
            chatViewModel.saveCurrentConversation()
        }, onSwipeFromLeftToRight: {
            chatViewModel.changeCurrentConversationToNext()
        }, onSwipeFromRightToLeft: {
            chatViewModel.changeCurrentConversationToPrevious()
        }, onSwipeFromUpToDown: {
            
        }, onSwipeFromDownToUp: {
            
        }, onSwipeFromLeftToRightAfterLongPress: {
            
        }, onSwipeFromRightToLeftAfterLongPress: {
            
        }, onSwipeFromUpToDownAfterLongPress: {
            chatViewModel.deleteCurrentConversation()
        }, onSwipeFromDownToUpAfterLongPress: {
            
        })
        .onChange(of: voiceRecordingManager.transcript) { newTranscript in
//            chatViewModel.addNewMessageWith(transcript: newTranscript)
            chatViewModel.addNewMessageWithImage(transcript: newTranscript)
        }
        .fullScreenCover(isPresented: $chatViewModel.showCamera) {
            SingleTakeCameraViewControllerRepresentable(chatViewModel: chatViewModel)
        }
    }
    
    
}

#Preview {
    let tabBarStateManager: TabBarStateManager = TabBarStateManager()
    
    return ChatView()
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
        
        static let navigationTitle: String = "Chat"
        static let toolbarButtonMessageDeleteImageName: String = "trash"
        static let toolbarButtonPhotoImageName: String = "photo"
    }
    
    struct NavigationBar: View {
        @EnvironmentObject private var chatViewModel: ChatViewModel
        
        var body: some View {
            CustomNavigationBar(title: Views.Constants.navigationTitle,
                                leadingItem: {
                Button {
                    chatViewModel.deleteCurrentConversation()
                } label: {
                    Image(systemName: Views.Constants.toolbarButtonMessageDeleteImageName)
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
                    chatViewModel.showCamera = true
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
