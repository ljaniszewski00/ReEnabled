import SwiftUI

struct CurrencyDetectorViewControllerRepresentable: UIViewControllerRepresentable {
    private var currencyDetectorViewModel: CurrencyDetectorViewModel
    
    init(currencyDetectorViewModel: CurrencyDetectorViewModel) {
        self.currencyDetectorViewModel = currencyDetectorViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return CurrencyDetectorViewController(currencyDetectorViewModel: currencyDetectorViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
