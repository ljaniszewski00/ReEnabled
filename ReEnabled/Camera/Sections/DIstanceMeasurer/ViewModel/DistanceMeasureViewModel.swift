import SwiftUI

class DistanceMeasureViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var distanceString: String = ""
    
    private init() {}
    
    static var shared: DistanceMeasureViewModel = {
        return DistanceMeasureViewModel()
    }()
}

extension DistanceMeasureViewModel: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
