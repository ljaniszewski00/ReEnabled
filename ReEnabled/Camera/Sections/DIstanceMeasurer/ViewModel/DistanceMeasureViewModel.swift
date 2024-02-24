import SwiftUI

class DistanceMeasureViewModel: ObservableObject {
    @Published var distance: Float = 0.0
    
    var distanceToDisplay: String {
        "Distance: \(String(format: "%.2f", distance)) meters"
    }
    
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
