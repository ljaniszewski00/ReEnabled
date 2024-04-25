import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    private let loopMode: LottieLoopMode
    private let contentMode: UIView.ContentMode
    private let rotationAngleDegrees: CGFloat
    private let paused: Bool
    private let shouldPlay: Binding<Bool>
    
    private var animationView: LottieAnimationView?
    
    init(name: String, 
         loopMode: LottieLoopMode = .loop,
         contentMode: UIView.ContentMode = .scaleAspectFit,
         rotationAngleDegrees: CGFloat = 0,
         paused: Bool = false,
         shouldPlay: Binding<Bool> = .constant(true)) {
        self.loopMode = loopMode
        self.contentMode = contentMode
        self.rotationAngleDegrees = rotationAngleDegrees
        self.paused = paused
        self.shouldPlay = shouldPlay
        self.animationView = .init(name: name)
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        guard let animationView = animationView else {
            return view
        }
        
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore
        
        if shouldPlay.wrappedValue {
            animationView.play()
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        let rotationAngle: CGFloat = convertDegreesToRadians(degrees: rotationAngleDegrees)
        var transformation: CGAffineTransform = CGAffineTransform.identity
        transformation = transformation.rotated(by: rotationAngle)
        view.transform = transformation
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        if shouldPlay.wrappedValue {
            context.coordinator.parent.animationView?.play { finished in
                if context.coordinator.parent.animationView?.loopMode == .playOnce && finished {
                    context.coordinator.parent.animationView?.play()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                        shouldPlay.wrappedValue = false
                        context.coordinator.parent.animationView?.pause()
                    }
                }
            }
        } else {
            context.coordinator.parent.animationView?.pause()
        }
    }
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

    class Coordinator: NSObject {
        var parent: LottieView

        init(_ parent: LottieView) {
            self.parent = parent
        }
    }
}
