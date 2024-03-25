import SwiftUI

struct FacialRecognizerViewControllerRepresentable: UIViewControllerRepresentable {
    private var facialRecognizerViewModel: FacialRecognizerViewModel
    
    init(facialRecognizerViewModel: FacialRecognizerViewModel) {
        self.facialRecognizerViewModel = facialRecognizerViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return FacialRecognizerViewController(facialRecognizerViewModel: facialRecognizerViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
