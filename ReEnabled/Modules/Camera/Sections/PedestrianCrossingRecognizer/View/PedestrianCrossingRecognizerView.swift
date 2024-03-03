import SwiftUI

struct PedestrianCrossingRecognizerView: View {
    @StateObject private var pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel = PedestrianCrossingRecognizerViewModel()
    
    var body: some View {
        PedestrianCrossingRecognizerViewControllerRepresentable(pedestrianCrossingRecognizerViewModel: pedestrianCrossingRecognizerViewModel)
    }
}

#Preview {
    PedestrianCrossingRecognizerView()
}
