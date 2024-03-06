import SwiftUI

struct RoadLightsRecognizerView: View {
    @StateObject private var roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel = RoadLightsRecognizerViewModel()
    
    var body: some View {
        RoadLightsRecognizerViewControllerRepresentable(roadLightsRecognizerViewModel: roadLightsRecognizerViewModel)
    }
}

#Preview {
    RoadLightsRecognizerView()
}
