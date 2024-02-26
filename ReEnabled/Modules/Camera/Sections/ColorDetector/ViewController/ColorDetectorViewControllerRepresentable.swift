import SwiftUI

struct ColorDetectorViewControllerRepresentable: UIViewControllerRepresentable {
    private var colorDetectorViewModel: ColorDetectorViewModel
    
    init(colorDetectorViewModel: ColorDetectorViewModel) {
        self.colorDetectorViewModel = colorDetectorViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return ColorDetectorViewController(colorDetectorViewModel: colorDetectorViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
