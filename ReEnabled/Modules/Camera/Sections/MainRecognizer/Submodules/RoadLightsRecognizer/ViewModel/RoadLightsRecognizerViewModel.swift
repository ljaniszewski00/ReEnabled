import SwiftUI

final class RoadLightsRecognizerViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var roadLightDetected: Bool = false
}
