import SwiftUI

final class RoadTrafficRecognizerViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var recognizedRoadSign: String = ""
    @Published var recognizedRoadLight: String = ""
}
