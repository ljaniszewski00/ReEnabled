import SwiftUI

final class FacialRecognizerViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var recognizedGender: String = ""
    @Published var recognizedAge: String = ""
    @Published var recognizedEmotion: String = ""
}
