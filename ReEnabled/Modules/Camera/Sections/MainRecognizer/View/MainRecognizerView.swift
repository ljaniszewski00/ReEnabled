import SwiftUI

struct MainRecognizerView: View {
    @StateObject private var objectsRecognizerViewModel: ObjectsRecognizerViewModel = ObjectsRecognizerViewModel()
    @StateObject private var distanceMeasurerViewModel: DistanceMeasureViewModel = DistanceMeasureViewModel()
    @StateObject private var roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel = RoadLightsRecognizerViewModel()
    @StateObject private var pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel = PedestrianCrossingRecognizerViewModel()
    
    var body: some View {
        MainRecognizerViewControllerRepresentable(objectsRecognizerViewModel: objectsRecognizerViewModel,
                                                  distanceMeasurerViewModel: distanceMeasurerViewModel,
                                                  roadLightsRecognizerViewModel: roadLightsRecognizerViewModel,
                                                  pedestrianCrossingRecognizerViewModel: pedestrianCrossingRecognizerViewModel)
    }
}

#Preview {
    MainRecognizerView()
}
