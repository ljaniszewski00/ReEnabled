import SwiftUI

struct ObjectsRecognizerViewControllerRepresentable: UIViewControllerRepresentable {
    private var objectsRecognizerViewModel: ObjectsRecognizerViewModel
    
    init(objectsRecognizerViewModel: ObjectsRecognizerViewModel) {
        self.objectsRecognizerViewModel = objectsRecognizerViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return ObjectsRecognizerViewController(objectsRecognizerViewModel: objectsRecognizerViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
