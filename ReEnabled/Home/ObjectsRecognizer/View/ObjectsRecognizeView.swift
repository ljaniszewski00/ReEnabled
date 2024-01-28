import SwiftUI

struct ObjectsRecognizerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ObjectsRecognizeViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
