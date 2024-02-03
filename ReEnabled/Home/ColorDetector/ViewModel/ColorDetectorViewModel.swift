import SwiftUI

class ColorDetectorViewModel: ObservableObject {
    @Published var readyToDisplay: Bool = false
    @Published var detectedColor: UIColor?
    
    var detectedColorName: String? {
        detectedColor?.accessibilityName
    }
    
    private init() {}
    
    static var shared: ColorDetectorViewModel = {
        return ColorDetectorViewModel()
    }()
}

extension ColorDetectorViewModel: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
