import SwiftUI

extension View {
    func onTwoTouchSwipe(direction: UISwipeGestureRecognizer.Direction,
                         onSwipe: @escaping () -> ()) -> some View {
        self.modifier(
            MultipleTouchSwipeView(
                numberOfTouchesRequired: 2,
                direction: direction,
                onSwipe: onSwipe
            )
        )
    }
    
    func onThreeTouchSwipe(direction: UISwipeGestureRecognizer.Direction,
                           onSwipe: @escaping () -> ()) -> some View {
        self.modifier(
            MultipleTouchSwipeView(
                numberOfTouchesRequired: 3,
                direction: direction,
                onSwipe: onSwipe
            )
        )
    }
}

private struct MultipleTouchSwipeView: ViewModifier {
    let numberOfTouchesRequired: Int
    let direction: UISwipeGestureRecognizer.Direction
    let onSwipe: () -> ()
    
    func body(content: Content) -> some View {
        content.background {
            SwipeableViewRepresentable(numberOfTouchesRequired: numberOfTouchesRequired,
                                       direction: direction) { _ in
                onSwipe()
            }
        }
    }
}

private struct SwipeableViewRepresentable: UIViewRepresentable {
    let numberOfTouchesRequired: Int
    let direction: UISwipeGestureRecognizer.Direction
    let onSwipe: (UISwipeGestureRecognizer) -> Void

    typealias UIViewType = UIView

    func makeCoordinator() -> SwipeCoordinator {
        SwipeCoordinator(onSwipe: self.onSwipe)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: context.coordinator,
                                                       action: #selector(SwipeCoordinator.handleSwipe(sender:)))
        swipeRecognizer.numberOfTouchesRequired = numberOfTouchesRequired
        swipeRecognizer.direction = direction
       
        view.addGestureRecognizer(swipeRecognizer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class SwipeCoordinator {
        let onSwipe: (UISwipeGestureRecognizer) -> Void

        init(onSwipe: @escaping (UISwipeGestureRecognizer) -> Void) {
            self.onSwipe = onSwipe
        }

        @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
            self.onSwipe(sender)
        }
    }
}
