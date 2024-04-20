import SwiftUI

final class ObjectsRecognizerViewModel: ObservableObject {
    @Published var recognizedObjectsNames: Set<String> = []
    
    private let feedbackManager: FeedbackManager = .shared
    
    func readRecognizedObjects() {
        if feedbackManager.speechFeedbackIsBeingGenerated {
            feedbackManager.stopSpeechFeedback()
        } else {
            let recognizedObjectsNames = getRecognizedObjectsFormattedToSpeech()
            
            if recognizedObjectsNames.isEmpty {
                feedbackManager.generateSpeechFeedback(with: .camera(.mainRecognizer(.noObjectsRecognized)),
                                                       and: recognizedObjectsNames)
            } else {
                feedbackManager.generateSpeechFeedback(with: .camera(.mainRecognizer(.followingObjectsHaveBeenRecognized)),
                                                       and: recognizedObjectsNames)
            }
        }
    }
    
    private func getRecognizedObjectsFormattedToSpeech() -> String {
        var textToSpeech: String = ""
        
        for recognizedObjectsName in recognizedObjectsNames {
            textToSpeech += "\(recognizedObjectsName), "
        }
        
        return textToSpeech
    }
}
