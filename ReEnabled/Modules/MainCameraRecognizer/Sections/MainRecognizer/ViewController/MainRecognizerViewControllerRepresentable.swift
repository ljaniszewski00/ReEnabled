import SwiftUI

struct MainRecognizerViewControllerRepresentable: UIViewControllerRepresentable {
    private var objectsRecognizerViewModel: ObjectsRecognizerViewModel
    private var distanceMeasurerViewModel: DistanceMeasurerViewModel
    private var roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel
    
    init(objectsRecognizerViewModel: ObjectsRecognizerViewModel,
         distanceMeasurerViewModel: DistanceMeasurerViewModel,
         roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel) {
        self.objectsRecognizerViewModel = objectsRecognizerViewModel
        self.distanceMeasurerViewModel = distanceMeasurerViewModel
        self.roadLightsRecognizerViewModel = roadLightsRecognizerViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return MainRecognizerViewController(objectsRecognizerViewModel: objectsRecognizerViewModel,
                                            distanceMeasurerViewModel: distanceMeasurerViewModel,
                                            roadLightsRecognizerViewModel: roadLightsRecognizerViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
