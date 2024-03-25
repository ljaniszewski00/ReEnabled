import SwiftUI

struct LightDetectorView: View {
    @StateObject private var lightDetectorViewModel: LightDetectorViewModel = LightDetectorViewModel()
    
    var body: some View {
        ZStack {
            LightDetectorViewControllerRepresentable(lightDetectorViewModel: lightDetectorViewModel)
                .opacity(lightDetectorViewModel.canDisplayCamera ? 1 : 0)
            
            VStack {
                Spacer()
                
                if let luminosity = lightDetectorViewModel.detectedLuminosity {
                    Text(luminosity)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.bottom, Views.Constants.luminocityToDisplayBottomPadding)
                }
            }
        }
    }
}

#Preview {
    ColorDetectorView()
}

private extension Views {
    struct Constants {
        static let luminocityToDisplayBottomPadding: CGFloat = 100
    }
}
