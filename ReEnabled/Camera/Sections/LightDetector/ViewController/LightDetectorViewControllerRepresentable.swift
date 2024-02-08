import SwiftUI

struct LightDetectorViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return LightDetectorViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
