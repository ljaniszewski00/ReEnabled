import Foundation

class SplashScreenViewModel: ObservableObject {
    @Published var shouldDisplayContent: Bool = false
    
    init() {
        displayContent()
    }
    
    func displayContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.shouldDisplayContent = true
        }
    }
}
