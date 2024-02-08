import SwiftUI

struct ColorDetectorView: View {
    @StateObject private var colorDetectorViewModel: ColorDetectorViewModel = .shared
    
    var body: some View {
        ZStack {
            ColorDetectorViewControllerRepresentable()
                .opacity(colorDetectorViewModel.canDisplayCamera ? 1 : 0)
            
            VStack {
                Spacer()
                
                if let colorName = colorDetectorViewModel.detectedColorName {
                    Text(colorName)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.bottom, Views.Constants.colorToDisplayBottomPadding)
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
        static let colorToDisplayBottomPadding: CGFloat = 100
    }
}
