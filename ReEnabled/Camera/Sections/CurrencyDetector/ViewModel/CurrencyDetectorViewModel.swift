import SwiftUI

class CurrencyDetectorViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    @Published var detectedCurrency: String?
    
    private init() {}
    
    static var shared: CurrencyDetectorViewModel = {
        return CurrencyDetectorViewModel()
    }()
}

extension CurrencyDetectorViewModel: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
