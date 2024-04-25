import SwiftUI

struct MainRecognizerView: View {
    @EnvironmentObject private var mainCameraRecognizerViewModel: MainCameraRecognizerViewModel
    
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var voiceRequestor: VoiceRequestor = .shared
    
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
                    if let recognizedLightColor = roadLightsRecognizerViewModel.roadLightType {
                        Text(recognizedLightColor)
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, Views.Constants.recognitionsLabelsVerticalPadding)
                            .padding(.horizontal)
                            .background (
                                .ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: Views.Constants.recognitionsLabelsBackgroundCornerRadius,
                                                     style: .continuous)
                            )
                            .padding(.bottom)
                    }
                    
//                    if let recognizedLightColor = roadLightsRecognizerViewModel.roadLightType,
//                       let personMovementInstruction = pedestrianCrossingRecognizerViewModel.personMovementInstruction,
//                       let deviceMovementInstruction = pedestrianCrossingRecognizerViewModel.deviceMovementInstruction {
//                        Text(recognizedLightColor)
//                            .padding(.bottom)
//                        Text(personMovementInstruction)
//                        Text(deviceMovementInstruction)
//                            .padding(.bottom)
//                    }
                    
                    if let distanceString = distanceMeasurerViewModel.distanceString {
                        Text(distanceString)
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, Views.Constants.recognitionsLabelsVerticalPadding)
                            .padding(.horizontal)
                            .background (
                                .ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: Views.Constants.recognitionsLabelsBackgroundCornerRadius,
                                                     style: .continuous)
                            )
                    }
                }
                .foregroundColor(.white)
                .font(.headline)
            }
            .padding(.bottom, Views.Constants.recognitionsBottomPadding)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                feedbackManager.generateSpeechFeedback(with: .camera(.mainRecognizer(.welcomeHint)))
            }
        }
        .onChange(of: roadLightsRecognizerViewModel.roadLightTypeRecognized) { _, _ in
            roadLightsRecognizerViewModel.readRoadLightType()
        }
//        .onChange(of: pedestrianCrossingRecognizerViewModel.personMovementInstruction) { _, personMovementInstruction in
//            pedestrianCrossingRecognizerViewModel.readPersonMovementInstruction()
//        }
//        .onChange(of: pedestrianCrossingRecognizerViewModel.deviceMovementInstruction) { _, deviceMovementInstruction in
//            pedestrianCrossingRecognizerViewModel.readDeviceMovementInstruction()
//        }
        .onChange(of: distanceMeasurerViewModel.obstacleIsNear) { _, isNear in
            if tabBarStateManager.tabSelection == .camera &&
                mainCameraRecognizerViewModel.cameraMode == .mainRecognizer &&
                isNear {
                distanceMeasurerViewModel.warnAboutObstacle()
            }
        }
        .onChange(of: voiceRequestor.selectedVoiceRequest) { _, voiceRequest in
            guard voiceRequest != VoiceRequest.empty else {
                return
            }
            
            switch voiceRequest {
            case .camera(.mainRecognizer(.readObjects)):
                objectsRecognizerViewModel.readRecognizedObjects()
            case .other(.remindVoiceCommands):
                guard tabBarStateManager.tabSelection == .camera && mainCameraRecognizerViewModel.cameraMode == .mainRecognizer else {
                    return
                }
                
                let actionScreen = ActionScreen(screenType: .mainRecognizer)
                feedbackManager.generateVoiceRequestsReminder(for: actionScreen)
            case .other(.remindGestures):
                guard tabBarStateManager.tabSelection == .camera && mainCameraRecognizerViewModel.cameraMode == .mainRecognizer else {
                    return
                }
                let actionScreen = ActionScreen(screenType: .mainRecognizer)
                feedbackManager.generateGesturesReminder(for: actionScreen)
            default:
                return
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
        static let recognitionsLabelsVerticalPadding: CGFloat = 15
        static let recognitionsLabelsBackgroundCornerRadius: CGFloat = 10
        static let recognitionsBottomPadding: CGFloat = 120
    }
}
