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
                    
                    if let distanceString = distanceMeasurerViewModel.distanceString {
                        Text(distanceString)
                    }
                }
                .foregroundColor(.white)
                .font(.headline)
            }
            .padding(.bottom, Views.Constants.recognitionsBottomPadding)
        }
        .onChange(of: roadLightsRecognizerViewModel.roadLightType) { _, roadLight in
            
        }
        .onChange(of: pedestrianCrossingRecognizerViewModel.personMovementInstruction) { _, personMovementInstruction in
            
        }
        .onChange(of: pedestrianCrossingRecognizerViewModel.deviceMovementInstruction) { _, deviceMovementInstruction in
            
        }
        .onChange(of: distanceMeasurerViewModel.obstacleIsNear) { _, isNear in
            if isNear {
                feedbackManager.generateHapticFeedback(.impact(.heavy))
                feedbackManager.generateSpeechFeedback(with: .camera(.mainRecognizer(.distanceWarning)))
            }
        }
        .addGesturesActions(toExecuteBeforeEveryAction: {
        }, toExecuteAfterEveryAction: {
            feedbackManager.generateHapticFeedbackForSwipeAction()
        }, onTap: {
            objectsRecognizerViewModel.readRecognizedObjects()
        }, onDoubleTap: {
        }, onTrippleTap: {
            mainCameraRecognizerViewModel.speakCameraModeName()
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
