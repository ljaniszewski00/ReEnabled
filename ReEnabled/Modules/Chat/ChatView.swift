import SwiftUI

struct ChatView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var chatViewModel: ChatViewModel = ChatViewModel()
    
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
                    .if(chatViewModel.selectedImage == nil) {
                        $0.padding(.bottom)
                    }
                }
                
                if let image = chatViewModel.selectedImage {
                    Views.ToBeSendSection(image: image)
                        .environmentObject(chatViewModel)
                }
            }
            .padding(.bottom, Views.Constants.scrollViewBottomPadding)
        }
        .addGesturesActions(onTap: {
            if !chatViewModel.speechRecordingBlocked {
                voiceRecordingManager.manageTalking()
            }
//            chatViewModel.addNewMessageWithImage(transcript: Message.mockData6.content)
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
        .onChange(of: voiceRecordingManager.transcript) { _, newTranscript in
//            chatViewModel.addNewMessageWith(transcript: newTranscript)
            chatViewModel.addNewMessageWithImage(transcript: newTranscript)
        }
        .onChange(of: voiceRecordingManager.isRecording) { _, isRecording in
            tabBarStateManager.shouldAnimateChatTabIcon = isRecording
        }
        .fullScreenCover(isPresented: $chatViewModel.showCamera) {
            SingleTakeCameraViewControllerRepresentable(chatViewModel: chatViewModel)
        }
    }
    
    
}

#Preview {
    ChatView()
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
        
        static let toBeSendVStackSpacing: CGFloat = 10
        static let toBeSendLabel: String = "To be send"
        static let toBeSendImageWidth: CGFloat = 80
        static let toBeSendImageHeight: CGFloat = 60
        static let toBeSendRemoveButtonImageName: String = "x.circle"
        static let toBeSendRemoveButtonImageWidth: CGFloat = 18
        static let toBeSendRemoveButtonImageHeight: CGFloat = 16
        static let toBeSendBottomPadding: CGFloat = scrollViewBottomPadding * 2
        
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
    
    struct ToBeSendSection: View {
        @EnvironmentObject private var chatViewModel: ChatViewModel
        let image: UIImage
        
        var body: some View {
            VStack(spacing: Views.Constants.toBeSendVStackSpacing) {
                LabelledDivider(label: Views.Constants.toBeSendLabel)
                
                HStack(alignment: .center) {
                    Button {
                        chatViewModel.selectedImage = nil
                    } label: {
                        Image(systemName: Views.Constants.toBeSendRemoveButtonImageName)
                            .resizable()
                            .frame(width: Views.Constants.toBeSendRemoveButtonImageWidth,
                                   height: Views.Constants.toBeSendRemoveButtonImageHeight)
                            .foregroundStyle(.gray)
                    }
                    
                    Image(uiImage: image)
                        .resizable(resizingMode: .stretch)
                        .frame(width: Views.Constants.toBeSendImageWidth,
                               height: Views.Constants.toBeSendImageHeight)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius:
                                    Views.Constants.messageCellImageClipShapeCornerRadius
                            )
                        )
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.leading)
            }
            .padding(.bottom, Views.Constants.toBeSendBottomPadding)
        }
    }
}
