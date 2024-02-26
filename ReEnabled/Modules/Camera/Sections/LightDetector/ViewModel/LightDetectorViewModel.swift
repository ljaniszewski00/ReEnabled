import SwiftUI

class LightDetectorViewModel: ObservableObject {
    @Published var luminosity: Double?
    @Published var canDisplayCamera: Bool = false
    
    var detectedLuminosity: String? {
        guard let luminosity = luminosity else {
            return nil
        }
        
        return "\(String(format: "%.2f", luminosity))"
    }
}
