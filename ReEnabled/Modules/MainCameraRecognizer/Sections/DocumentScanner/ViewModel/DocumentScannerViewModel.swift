import Foundation

final class DocumentScannerViewModel: ObservableObject {
    @Published var detectedTexts: Set<String> = []
    @Published var detectedBarCodesStringValues: Set<String> = []
    
    private var feedbackManager: FeedbackManager = .shared
    
    func readDetectedTexts() {
        if feedbackManager.speechFeedbackIsBeingGenerated {
            feedbackManager.stopSpeechFeedback()
        } else {
            guard !detectedTexts.isEmpty else {
                feedbackManager.generateSpeechFeedback(with: .camera(.documentScanner(.noTextHasBeenRecognized)))
                return
            }
            
            var outputString: String = ""
            for text in detectedTexts {
                outputString += "\(text), "
            }
            
            feedbackManager.generateSpeechFeedback(with: .camera(.documentScanner(.hereIsRecognizedText)),
                                                   and: outputString)
        }
    }
    
    func readDetectedBarCodesValues() {
        if feedbackManager.speechFeedbackIsBeingGenerated {
            feedbackManager.stopSpeechFeedback()
        } else {
            guard !detectedBarCodesStringValues.isEmpty else {
                feedbackManager.generateSpeechFeedback(with: .camera(.documentScanner(.noBarCodesHaveBeenRecognized)))
                return
            }
            
            var outputString: String = ""
            for text in detectedBarCodesStringValues {
                outputString += "\(text), "
            }
            
            feedbackManager.generateSpeechFeedback(with: .camera(.documentScanner(.hereIsRecognizedBarCodeText)),
                                                   and: outputString)
        }
    }
}
