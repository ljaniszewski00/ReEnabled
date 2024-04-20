import SwiftUI

final class RoadLightsRecognizerViewModel: ObservableObject {
    @Published var roadLightTypeRecognized: RoadLightType?
    
    private let feedbackManager: FeedbackManager = .shared
    
    var roadLightType: String? {
        guard let roadLightTypeRecognized = roadLightTypeRecognized,
              roadLightTypeRecognized != .none else {
            return nil
        }
        
        return roadLightTypeRecognized.rawValue
    }
    
    func readRoadLightType() {
        guard let roadLightTypeRecognized = roadLightTypeRecognized else {
            return
        }
        
        switch roadLightTypeRecognized {
        case .red:
            feedbackManager.generateSpeechFeedback(with: .camera(.mainRecognizer(.redLightHasBeenDetected)))
        case .green:
            feedbackManager.generateSpeechFeedback(with: .camera(.mainRecognizer(.greenLightHasBeenDetected)))
        case .none:
            return
        }
    }
}
