import SwiftUI

struct CurrencyDetectorViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return CurrencyDetectorViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
