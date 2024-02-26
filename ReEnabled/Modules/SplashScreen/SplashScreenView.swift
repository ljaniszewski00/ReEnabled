import SwiftUI

struct SplashScreenView: View {
    @StateObject private var viewModel: SplashScreenViewModel = SplashScreenViewModel()
    
    var body: some View {
        if viewModel.shouldDisplayContent {
            ContentView()
                .transition(.move(edge: .trailing))
                .animation(.default)
        } else {
            VStack {
                Spacer()
                
                Image(Views.Constants.logoImageName)
                    .resizable()
                    .scaledToFit()
                
                Spacer()
            }
            .transition(.move(edge: .leading))
            .animation(.default)
            .padding()
        }
    }
}

#Preview {
    SplashScreenView()
}

private extension Views {
    struct Constants {
        static let logoImageName: String = "Logo"
    }
}

