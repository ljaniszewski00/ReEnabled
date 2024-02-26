import SwiftUI

final class ColorDetectorViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var detectedColor: UIColor?
    
    var detectedColorName: String? {
        detectedColor?.accessibilityName
    }
}
