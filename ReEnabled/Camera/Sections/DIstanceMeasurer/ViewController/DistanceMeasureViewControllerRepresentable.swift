import SwiftUI

struct DistanceMeasureViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return DistanceMeasureViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
