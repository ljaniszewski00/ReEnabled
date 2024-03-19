import SwiftUI

struct SingleTakeCameraViewControllerRepresentable: UIViewControllerRepresentable {
    private var searchViewModel: SearchViewModel
    
    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return SingleTakeCameraViewController(searchViewModel: searchViewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
