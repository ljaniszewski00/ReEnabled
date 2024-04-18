import SwiftUI

final class PedestrianCrossingRecognizerViewModel: ObservableObject {
    @Published var pedestrianCrossingPrediction: PedestrianCrossingPrediction?
    @Published var canDisplayCamera: Bool = false
    
    private let feedbackManager: FeedbackManager = .shared
    
    var recognizedLightColor: String? {
        if let lightColor = pedestrianCrossingPrediction?.lightColor,
           lightColor != .none {
            return "Detected light color: \(lightColor)"
        } else {
            return "Could not detect road light."
        }
    }
    
    var personMovementInstruction: String? {
        guard pedestrianCrossingPrediction?.lightColor != nil,
              pedestrianCrossingPrediction?.lightColor != PedestrianCrossingLightType.none  else {
            return nil
        }
        
        switch pedestrianCrossingPrediction?.personMovementInstruction {
        case .goodPosition:
            return SpeechFeedback.camera(.mainRecognizer(.personGoodPosition)).rawValue
        case .moveLeft:
            return SpeechFeedback.camera(.mainRecognizer(.personMoveLeft)).rawValue
        case .moveRight:
            return SpeechFeedback.camera(.mainRecognizer(.personMoveRight)).rawValue
        case nil:
            return nil
        }
    }
    
    var deviceMovementInstruction: String? {
        guard pedestrianCrossingPrediction?.lightColor != nil,
              pedestrianCrossingPrediction?.lightColor != PedestrianCrossingLightType.none else {
            return nil
        }
        
        switch pedestrianCrossingPrediction?.deviceMovementInstruction {
        case .goodOrientation:
            return SpeechFeedback.camera(.mainRecognizer(.deviceGoodOrientation)).rawValue
        case .turnLeft:
            return SpeechFeedback.camera(.mainRecognizer(.deviceTurnLeft)).rawValue
        case .turnRight:
            return SpeechFeedback.camera(.mainRecognizer(.deviceTurnRight)).rawValue
        case nil:
            return nil
        }
    }
    
    func readPersonMovementInstruction() {
        guard let personMovementInstruction = personMovementInstruction else {
            return
        }
        
        feedbackManager.generateSpeechFeedback(with: personMovementInstruction)
    }
    
    func readDeviceMovementInstruction() {
        guard let deviceMovementInstruction = deviceMovementInstruction else {
            return
        }
        
        feedbackManager.generateSpeechFeedback(with: deviceMovementInstruction)
    }
}
