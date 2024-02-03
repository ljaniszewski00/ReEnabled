import SwiftUI

struct ColorDetectorViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ColorDetectorViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
