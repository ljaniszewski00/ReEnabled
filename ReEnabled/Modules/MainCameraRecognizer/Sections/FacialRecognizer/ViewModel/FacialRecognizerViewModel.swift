import SwiftUI

final class FacialRecognizerViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var recognizedGender: String = ""
    @Published var recognizedAge: String = ""
    @Published var recognizedEmotion: String = ""
    
    var recognitionEnabled: Bool {
        get {
            if !recognizeGender && !recognizeAge && !recognizeEmotions {
                return false
            } else {
                return true
            }
        }
        
        set {
            recognizeGender = newValue
            recognizeAge = newValue
            recognizeEmotions = newValue
        }
    }
    
    var recognizeGender: Bool = true
    var recognizeAge: Bool = true
    var recognizeEmotions: Bool = true
    
    func enableRecognition() {
        recognitionEnabled = true
    }
}
