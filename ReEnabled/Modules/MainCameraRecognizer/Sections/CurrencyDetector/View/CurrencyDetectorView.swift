import SwiftUI

struct CurrencyDetectorView: View {
    @StateObject private var currencyDetectorViewModel: CurrencyDetectorViewModel = CurrencyDetectorViewModel()
    
    var body: some View {
        ZStack {
            CurrencyDetectorViewControllerRepresentable(currencyDetectorViewModel: currencyDetectorViewModel)
            
            VStack {
                Spacer()
                
                if let detectedCurrency = currencyDetectorViewModel.detectedCurrency {
                    Text(detectedCurrency)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.bottom, Views.Constants.currencyToDisplayBottomPadding)
                }
            }
        }
    }
}

#Preview {
    CurrencyDetectorView()
}

private extension Views {
    struct Constants {
        static let currencyToDisplayBottomPadding: CGFloat = 100
    }
}
