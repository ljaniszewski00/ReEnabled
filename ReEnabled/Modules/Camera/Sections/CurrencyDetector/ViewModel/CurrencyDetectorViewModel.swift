import SwiftUI

class CurrencyDetectorViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var detectedCurrency: String?
}
