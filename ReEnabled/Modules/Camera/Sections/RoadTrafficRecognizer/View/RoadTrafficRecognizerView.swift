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
