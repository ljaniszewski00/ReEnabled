import SwiftUI

final class DistanceMeasurerViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var distanceString: String = ""
}
