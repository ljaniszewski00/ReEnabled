import SwiftUI

struct MainRecognizerViewControllerRepresentable: UIViewControllerRepresentable {
    private var objectsRecognizerViewModel: ObjectsRecognizerViewModel
    private var distanceMeasurerViewModel: DistanceMeasurerViewModel
    private var roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel
    private var pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel
    
    init(objectsRecognizerViewModel: ObjectsRecognizerViewModel,
         distanceMeasurerViewModel: DistanceMeasurerViewModel,
         roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel,
         pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel) {
        self.objectsRecognizerViewModel = objectsRecognizerViewModel
        self.distanceMeasurerViewModel = distanceMeasurerViewModel
        self.roadLightsRecognizerViewModel = roadLightsRecognizerViewModel
        self.pedestrianCrossingRecognizerViewModel = pedestrianCrossingRecognizerViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return MainRecognizerViewController(objectsRecognizerViewModel: objectsRecognizerViewModel,
                                            distanceMeasurerViewModel: distanceMeasurerViewModel,
                                            roadLightsRecognizerViewModel: roadLightsRecognizerViewModel,
                                            pedestrianCrossingRecognizerViewModel: pedestrianCrossingRecognizerViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
