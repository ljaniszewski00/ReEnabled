import SwiftUI

struct DistanceMeasureViewControllerRepresentable: UIViewControllerRepresentable {
    private var distanceMeasureViewModel: DistanceMeasureViewModel
    
    init(distanceMeasureViewModel: DistanceMeasureViewModel) {
        self.distanceMeasureViewModel = distanceMeasureViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return DistanceMeasureViewController(distanceMeasureViewModel: distanceMeasureViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
