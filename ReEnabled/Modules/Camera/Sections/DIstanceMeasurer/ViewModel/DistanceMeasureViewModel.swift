import SwiftUI

class DistanceMeasureViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var distanceString: String = ""
}
