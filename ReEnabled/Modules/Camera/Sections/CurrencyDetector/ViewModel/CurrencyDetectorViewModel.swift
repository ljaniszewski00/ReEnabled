import SwiftUI

final class CurrencyDetectorViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var detectedCurrency: String?
}
