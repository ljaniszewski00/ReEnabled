import SwiftUI

class ObjectsRecognizerViewModel: ObservableObject {
    @Published var canDisplayCamera: Bool = false
    
    private init() {}
    
    static var shared: ObjectsRecognizerViewModel = {
        return ObjectsRecognizerViewModel()
    }()
}

extension ObjectsRecognizerViewModel: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
