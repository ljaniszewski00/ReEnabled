import SwiftUI

struct OnboardingSectionView<Content: View>: View {
    @EnvironmentObject private var onboardingViewModel: OnboardingViewModel
    
    @StateObject private var feedbackManager: FeedbackManager = .shared
    
    let title: String?
    var image: UIImage? = nil
    @ViewBuilder var descriptionContent: () -> Content
    
    var body: some View {
        VStack {
            if let title = title {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                
                Spacer()
            }
            
            if let image = image {
                Spacer()
                
                Image(uiImage: image)
                    .resizable()
                    .frame(width: Views.Constants.imageSize,
                           height: Views.Constants.imageSize)
            }
            
            Spacer()
            
            descriptionContent()
            
            Spacer()
        }
        .padding()
        .contentShape(Rectangle())
    }
}

#Preview {
    OnboardingSectionView(title: "TITLE") {
        Text("This is description.")
    }
        .environmentObject(OnboardingViewModel())
}

private extension Views {
    struct Constants {
        static let mainVStackSpacing: CGFloat = 20
        static let imageSize: CGFloat = 300
    }
}
