import SwiftUI

struct PedestrianCrossingRecognizerViewControllerRepresentable: UIViewControllerRepresentable {
    private var pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel
    
    init(pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel) {
        self.pedestrianCrossingRecognizerViewModel = pedestrianCrossingRecognizerViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return PedestrianCrossingRecognizerViewController(pedestrianCrossingRecognizerViewModel: pedestrianCrossingRecognizerViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
