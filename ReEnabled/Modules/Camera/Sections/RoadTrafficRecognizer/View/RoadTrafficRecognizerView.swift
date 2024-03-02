import SwiftUI

struct RoadTrafficRecognizerView: View {
    @StateObject private var roadTrafficRecognizerViewModel: RoadTrafficRecognizerViewModel = RoadTrafficRecognizerViewModel()
    
    var body: some View {
        ZStack {
            RoadTrafficRecognizerViewControllerRepresentable(roadTrafficRecognizerViewModel: roadTrafficRecognizerViewModel)
            
            VStack {
                Spacer()
                
                Group {
                    Text("Road Sign: \(roadTrafficRecognizerViewModel.recognizedRoadSign)")
                    Text("Road Light: \(roadTrafficRecognizerViewModel.recognizedRoadLight)")
                }
                .foregroundColor(.white)
                .font(.headline)
            }
            .padding(.bottom, Views.Constants.recognitionsBottomPadding)
        }
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
