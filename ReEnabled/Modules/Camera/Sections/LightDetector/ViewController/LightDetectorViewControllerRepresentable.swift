import SwiftUI

struct LightDetectorViewControllerRepresentable: UIViewControllerRepresentable {
    private var lightDetectorViewModel: LightDetectorViewModel
    
    init(lightDetectorViewModel: LightDetectorViewModel) {
        self.lightDetectorViewModel = lightDetectorViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return LightDetectorViewController(lightDetectorViewModel: lightDetectorViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
