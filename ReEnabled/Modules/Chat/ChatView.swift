import RealmSwift
import SwiftUI

struct ChatView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var voiceRequestor: VoiceRequestor = .shared
    
    @StateObject private var chatViewModel: ChatViewModel = ChatViewModel()
    @StateObject private var voiceRecordingChatManager: VoiceRecordingChatManager = VoiceRecordingChatManager()
    
    @ObservedResults(ConversationObject.self) var conversationsObjects
    
    var body: some View {
        VStack(spacing: Views.Constants.mainVStackSpacing) {
            Views.NavigationBar()
                .environmentObject(chatViewModel)
            
            Group {
                ScrollView(.vertical) {
                    VStack {
                        if let currentConversation = chatViewModel.currentConversation {
                            if currentConversation.messages.isEmpty {
                                Views.EmptyConversationPlaceholder()
                                    .environmentObject(chatViewModel)
                                    .environmentObject(voiceRecordingManager)
                            } else {
                                ForEach(currentConversation.messages, id: \.id) { message in
                                    Views.MessageCell(message: message)
                                        .padding(.bottom, Views.Constants.messageCellBottomPadding)
                                }
                            }
                        }
                        
                        if chatViewModel.speechRecordingBlocked {
                            ProgressView()
                        }
                    }
                    .padding()
                    .if(chatViewModel.selectedImage == nil) {
                        $0.padding(.bottom, 
                                   tabBarStateManager.tabBarSize.height * Views.Constants.messageListBottomPaddingMultiplier)
                    }
                    .contentShape(Rectangle())
                }
                
                if let image = chatViewModel.selectedImage {
                    Views.ToBeSendSection(image: image)
                        .environmentObject(chatViewModel)
                }
            }
            .padding(.bottom, Views.Constants.scrollViewBottomPadding)
        }
        .onAppear {
            if tabBarStateManager.tabSelection == .chat {
                feedbackManager.generateSpeechFeedback(with: .other(.currentTab),
                                                       and: TabBarItem.chat.title)
            }
        }
        .addGesturesActions(toExecuteBeforeEveryAction: {
            feedbackManager.generateHapticFeedbackForSwipeAction()
        }, toExecuteAfterEveryAction: {
            feedbackManager.generateHapticFeedbackForSwipeAction()
        }, onTap: {
            if feedbackManager.speechFeedbackIsBeingGenerated {
                feedbackManager.stopSpeechFeedback()
            } else {
                chatViewModel.readConversation()
            }
        }, onDoubleTap: {
            if !chatViewModel.speechRecordingBlocked {
                voiceRecordingChatManager.manageTalking()
            }
        }, onTrippleTap: {
            
        }, onLongPress: {
            if !voiceRecordingChatManager.isRecordingChatMessage {
                voiceRecordingManager.manageTalking()
            }
        }, onSwipeFromLeftToRight: {
            chatViewModel.changeCurrentConversationToNext()
        }, onSwipeFromRightToLeft: {
            chatViewModel.changeCurrentConversationToPrevious()
        }, onSwipeFromLeftToRightAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.settings)
        }, onSwipeFromRightToLeftAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.camera)
        }, onSwipeFromUpToDownAfterLongPress: {
            chatViewModel.deleteCurrentConversation()
        }, onSwipeFromDownToUpAfterLongPress: {
            chatViewModel.selectPhoto()
        })
        .onChange(of: conversationsObjects) { _, updatedConversationsObjects in
            chatViewModel.getConversations(from: updatedConversationsObjects)
        }
        .onChange(of: voiceRecordingChatManager.chatMessageTranscript) { _, newTranscript in
            if !voiceRecordingChatManager.isRecordingChatMessage {
                chatViewModel.manageAddingMessageWith(transcript: newTranscript)
            }
        }
        .onChange(of: voiceRecordingChatManager.isRecordingChatMessage) { _, isRecording in
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
            case .chat(.sendMessage):
                if !chatViewModel.speechRecordingBlocked {
                    voiceRecordingChatManager.manageTalking()
                }
            case .chat(.describePhoto):
                chatViewModel.addNewMessageWithImageOnVoiceCommand()
            case .chat(.readConversation):
                chatViewModel.readConversation()
            case .chat(.deleteCurrentConversation):
                chatViewModel.deleteCurrentConversation()
            case .chat(.deleteAllConversations):
                chatViewModel.deleteAllConversations()
                    .sink { _ in
                    } receiveValue: { _ in
                        feedbackManager.generateSpeechFeedback(with: .chat(.allConversationsDeleted))
                    }
                    .store(in: &chatViewModel.cancelBag)
            default:
                return
            }
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
        
        static let emptyConversationPlaceholderVStackSpacing: CGFloat = 40
        static let emptyConversationPlaceholderImageName: String = "plus.message"
        static let emptyConversationPlaceholderImageSize: CGFloat = 200
        static let emptyConversationPlaceholderTextsVStackSpacing: CGFloat = 30
        static let emptyConversationPlaceholderTextTitle: String = "Looks like this conversation is empty"
        static let emptyConversationPlaceholderSubbuttonsVStackSpacing: CGFloat = 12
        static let emptyConversationPlaceholderTextDoubleTapAction: String = "Double tap the screen to record new message"
        static let emptyConversationPlaceholderTextLongPressSwipeUpAction: String = "Long press on one point of the screen, swipe up and release to upload a photo"
        static let emptyConversationPlaceholderTextLongPressAndSayAction: String = "Long press on one point of the screen and release, then say what you want to do"
        static let emptyConversationPlaceholderSubbuttonCornerRadius: CGFloat = 8
        static let emptyConversationPlaceholderTopPadding: CGFloat = 50
        
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
        
        static let messageListBottomPaddingMultiplier: CGFloat = 2.3
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
                                secondTrailingItem: {
                Button {
                    chatViewModel.selectPhoto()
                } label: {
                    Image(systemName: Views.Constants.toolbarButtonPhotoImageName)
                        .resizable()
                        .scaledToFill()
                }
            })
        }
    }
    
    struct EmptyConversationPlaceholder: View {
        @EnvironmentObject private var chatViewModel: ChatViewModel
        @EnvironmentObject private var voiceRecordingManager: VoiceRecordingManager
        
        var body: some View {
            VStack(spacing: Views.Constants.emptyConversationPlaceholderVStackSpacing) {
                Image(systemName: Views.Constants.emptyConversationPlaceholderImageName)
                    .resizable()
                    .frame(width: Views.Constants.emptyConversationPlaceholderImageSize,
                           height: Views.Constants.emptyConversationPlaceholderImageSize)
                    .padding(.bottom)
                
                VStack(spacing: Views.Constants.emptyConversationPlaceholderTextsVStackSpacing) {
                    Text(Views.Constants.emptyConversationPlaceholderTextTitle)
                        .font(.title2)
                        
                    
                    VStack(alignment: .leading, spacing: Views.Constants.emptyConversationPlaceholderSubbuttonsVStackSpacing) {
                        Views.EmptyConversationPlaceholderActionButton(label: Views.Constants.emptyConversationPlaceholderTextDoubleTapAction) {
                            if !chatViewModel.speechRecordingBlocked {
                                voiceRecordingManager.manageTalking()
                            }
                        }
                        
                        Views.EmptyConversationPlaceholderActionButton(label: Views.Constants.emptyConversationPlaceholderTextLongPressSwipeUpAction) {
                            chatViewModel.selectPhoto()
                        }
                        
                        Views.EmptyConversationPlaceholderActionButton(label: Views.Constants.emptyConversationPlaceholderTextLongPressAndSayAction) {
                            
                        }
                    }
                    .multilineTextAlignment(.leading)
                }
            }
            .foregroundStyle(.placeholder)
            .padding(.top, Views.Constants.emptyConversationPlaceholderTopPadding)
        }
    }
    
    struct EmptyConversationPlaceholderActionButton: View {
        let label: String
        let action: () -> ()
        
        var body: some View {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: Views.Constants.emptyConversationPlaceholderSubbuttonCornerRadius)
                    
                    Text(label)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding()
                }
            }
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
