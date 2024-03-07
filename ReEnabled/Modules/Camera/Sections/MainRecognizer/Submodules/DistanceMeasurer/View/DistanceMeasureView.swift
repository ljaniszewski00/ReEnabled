import SwiftUI

struct DistanceMeasureView: View {
    @StateObject private var distanceMeasureViewModel: DistanceMeasurerViewModel = DistanceMeasurerViewModel()
    
    var body: some View {
        ZStack {
            DistanceMeasureViewControllerRepresentable(distanceMeasureViewModel: distanceMeasureViewModel)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text(distanceMeasureViewModel.distanceString)
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
