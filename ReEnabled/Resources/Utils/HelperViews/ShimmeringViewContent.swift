import SwiftUI

struct ShimmeringViewContent<Content: View>: View {
    @ViewBuilder var content: Content
    
    @State private var moveGradient: Bool = true
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        
        Rectangle()
            .overlay {
                LinearGradient(colors: [
                    .clear, .white, .clear
                ],
                               startPoint: .leading,
                               endPoint: .trailing)
                .frame(width: Views.Constants.gradientFrameWidth)
                .offset(x: moveGradient ?
                        -screenWidth / Views.Constants.offsetDivider : screenWidth / Views.Constants.offsetDivider)
            }
            .animation(
                .linear(duration: Views.Constants.animationDuration)
                .repeatForever(autoreverses: false),
                value: moveGradient
            )
            .mask {
                content
            }
            .onAppear {
                moveGradient.toggle()
            }
    }
}

#Preview {
    ShimmeringViewContent {
        Text("Swipe to proceed")
    }
}

private extension Views {
    struct Constants {
        static let gradientFrameWidth: CGFloat = 100
        static let offsetDivider: CGFloat = 2
        static let animationDuration: CGFloat = 2.5
    }
}
