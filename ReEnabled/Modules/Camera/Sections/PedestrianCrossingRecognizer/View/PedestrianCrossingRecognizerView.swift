import SwiftUI

struct PedestrianCrossingRecognizerView: View {
    @StateObject private var pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel = PedestrianCrossingRecognizerViewModel()
    
    var body: some View {
        ZStack {
            PedestrianCrossingRecognizerViewControllerRepresentable(pedestrianCrossingRecognizerViewModel: pedestrianCrossingRecognizerViewModel)
            
            if let detectedLightColor = pedestrianCrossingRecognizerViewModel.detectedLightColor,
               let personMovementInstruction = pedestrianCrossingRecognizerViewModel.personMovementInstruction,
               let deviceMovementInstruction = pedestrianCrossingRecognizerViewModel.deviceMovementInstruction {
                VStack {
                    Spacer()
                    
                    Group {
                        Text(detectedLightColor)
                            .padding(.bottom)
                        Text(personMovementInstruction)
                        Text(deviceMovementInstruction)
                    }
                    .foregroundColor(.white)
                    .font(.headline)
                }
                .padding(.bottom, Views.Constants.recognitionsBottomPadding)
            }
        }
        
    }
}

#Preview {
    PedestrianCrossingRecognizerView()
}

private extension Views {
    struct Constants {
        static let recognitionsBottomPadding: CGFloat = 120
    }
}
