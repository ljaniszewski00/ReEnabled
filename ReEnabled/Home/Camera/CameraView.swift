import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return CameraViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
