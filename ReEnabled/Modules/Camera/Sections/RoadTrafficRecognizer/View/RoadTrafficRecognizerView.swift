import SwiftUI

struct RoadTrafficRecognizerView: View {
    @StateObject private var roadTrafficRecognizerViewModel: RoadTrafficRecognizerViewModel = RoadTrafficRecognizerViewModel()
    
    var body: some View {
        RoadTrafficRecognizerViewControllerRepresentable(roadTrafficRecognizerViewModel: roadTrafficRecognizerViewModel)
    }
}

#Preview {
    RoadTrafficRecognizerView()
}

private extension Views {
    struct Constants {
        static let recognitionsBottomPadding: CGFloat = 100
    }
}
