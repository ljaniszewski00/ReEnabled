import SwiftUI

struct DistanceMeasureView: View {
    @StateObject private var distanceMeasureViewModel: DistanceMeasureViewModel = .shared
    
    var body: some View {
        ZStack {
            DistanceMeasureViewRepresentable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                DetectorFrame()
                
                Spacer()
                
                Text(distanceMeasureViewModel.distanceToDisplay)
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.bottom, Views.Constants.distanceToDisplayBottomPadding)
            }
        }
    }
}

#Preview {
    DistanceMeasureView()
}

private extension Views {
    struct Constants {
        static let distanceToDisplayBottomPadding: CGFloat = 100
    }
}
