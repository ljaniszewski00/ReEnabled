import SwiftUI

struct RoadTrafficRecognizerViewControllerRepresentable: UIViewControllerRepresentable {
    private var roadTrafficRecognizerViewModel: RoadTrafficRecognizerViewModel
    
    init(roadTrafficRecognizerViewModel: RoadTrafficRecognizerViewModel) {
        self.roadTrafficRecognizerViewModel = roadTrafficRecognizerViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return RoadTrafficRecognizerViewController(roadTrafficRecognizerViewModel: roadTrafficRecognizerViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
