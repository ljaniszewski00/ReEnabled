import SwiftUI

struct RoadLightsRecognizerViewControllerRepresentable: UIViewControllerRepresentable {
    private var roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel
    
    init(roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel) {
        self.roadLightsRecognizerViewModel = roadLightsRecognizerViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return RoadLightsRecognizerViewController(roadLightsRecognizerViewModel: roadLightsRecognizerViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
