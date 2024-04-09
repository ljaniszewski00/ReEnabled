import SwiftUI

struct MainRecognizerView: View {
    @EnvironmentObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel
    
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    
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
        .addGesturesActions(toExecuteBeforeEveryAction: {
        }, toExecuteAfterEveryAction: {
            feedbackManager.generateHapticFeedbackForSwipeAction()
        }, onTap: {
        }, onDoubleTap: {
        }, onTrippleTap: {
        }, onLongPress: {
            voiceRecordingManager.manageTalking()
        }, onSwipeFromLeftToRight: {
            mainCameraRecognizerViewModel.changeToNextCameraMode()
        }, onSwipeFromRightToLeft: {
            mainCameraRecognizerViewModel.changeToPreviousCameraMode()
        }, onSwipeFromUpToDown: {
        }, onSwipeFromDownToUp: {
        }, onSwipeFromLeftToRightAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.chat)
        }, onSwipeFromRightToLeftAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.settings)
        }, onSwipeFromUpToDownAfterLongPress: {
        }, onSwipeFromDownToUpAfterLongPress: {
        })
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
