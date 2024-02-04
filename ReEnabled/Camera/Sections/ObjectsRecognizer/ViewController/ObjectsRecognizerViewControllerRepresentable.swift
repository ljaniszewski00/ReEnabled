import SwiftUI

struct ObjectsRecognizerViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ObjectsRecognizerViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
