import SwiftUI

final class RoadLightsRecognizerViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var roadLightTypeRecognized: RoadLightType?
    
    var roadLightType: String? {
        guard let roadLightTypeRecognized = roadLightTypeRecognized,
              roadLightTypeRecognized != .none else {
            return nil
        }
        
        return roadLightTypeRecognized.rawValue
    }
}
