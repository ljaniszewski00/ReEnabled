import SwiftUI

struct SingleTakeCameraViewControllerRepresentable: UIViewControllerRepresentable {
    private var chatViewModel: ChatViewModel
    
    init(chatViewModel: ChatViewModel) {
        self.chatViewModel = chatViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return SingleTakeCameraViewController(chatViewModel: chatViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
