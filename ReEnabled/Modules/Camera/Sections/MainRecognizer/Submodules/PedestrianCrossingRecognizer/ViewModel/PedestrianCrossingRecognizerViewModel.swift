import SwiftUI

final class PedestrianCrossingRecognizerViewModel: ObservableObject {
    @Published var pedestrianCrossingPrediction: PedestrianCrossingPrediction?
    @Published var canDisplayCamera: Bool = false
    
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
            return "Good Position"
        case .moveLeft:
            return "Please, move left."
        case .moveRight:
            return "Please, move right."
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
            return "Good Camera Orientation"
        case .turnLeft:
            return "Please, turn camera left"
        case .turnRight:
            return "Please, turn camera right"
        case nil:
            return nil
        }
    }
}
