import SwiftUI

struct MainRecognizerView: View {
    @StateObject private var objectsRecognizerViewModel: ObjectsRecognizerViewModel = ObjectsRecognizerViewModel()
    @StateObject private var distanceMeasurerViewModel: DistanceMeasurerViewModel = DistanceMeasurerViewModel()
    @StateObject private var roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel = RoadLightsRecognizerViewModel()
    @StateObject private var pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel = PedestrianCrossingRecognizerViewModel()
    
    var body: some View {
        ZStack {
            MainRecognizerViewControllerRepresentable(objectsRecognizerViewModel: objectsRecognizerViewModel,
                                                      distanceMeasurerViewModel: distanceMeasurerViewModel,
                                                      roadLightsRecognizerViewModel: roadLightsRecognizerViewModel,
                                                      pedestrianCrossingRecognizerViewModel: pedestrianCrossingRecognizerViewModel)
            
            VStack {
                Spacer()
                
                Group {
                    if let recognizedLightColor = roadLightsRecognizerViewModel.roadLightType,
                       let personMovementInstruction = pedestrianCrossingRecognizerViewModel.personMovementInstruction,
                       let deviceMovementInstruction = pedestrianCrossingRecognizerViewModel.deviceMovementInstruction {
                        Text(recognizedLightColor)
                            .padding(.bottom)
                        Text(personMovementInstruction)
                        Text(deviceMovementInstruction)
                            .padding(.bottom)
                    }
                    
                    Text(distanceMeasurerViewModel.distanceString)
                }
                .foregroundColor(.white)
                .font(.headline)
            }
            .padding(.bottom, Views.Constants.recognitionsBottomPadding)
        }
    }
}

#Preview {
    MainRecognizerView()
}

private extension Views {
    struct Constants {
        static let recognitionsBottomPadding: CGFloat = 120
    }
}
