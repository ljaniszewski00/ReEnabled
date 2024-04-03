import SwiftUI

extension View {
    func onTwoTouchSwipe(direction: UISwipeGestureRecognizer.Direction,
                         toExecuteBeforeSwipe: (() -> ())? = nil,
                         toExecuteAfterSwipe: (() -> ())? = nil,
                         onSwipe: @escaping () -> ()) -> some View {
        self.modifier(
            MultipleTouchSwipeView(
                numberOfTouchesRequired: 2,
                direction: direction,
                toExecuteBeforeSwipe: toExecuteBeforeSwipe,
                toExecuteAfterSwipe: toExecuteAfterSwipe,
                onSwipe: onSwipe
            )
        )
    }
    
    func onThreeTouchSwipe(direction: UISwipeGestureRecognizer.Direction,
                           toExecuteBeforeSwipe: (() -> ())? = nil,
                           toExecuteAfterSwipe: (() -> ())? = nil,
                           onSwipe: @escaping () -> ()) -> some View {
        self.modifier(
            MultipleTouchSwipeView(
                numberOfTouchesRequired: 3,
                direction: direction,
                toExecuteBeforeSwipe: toExecuteBeforeSwipe,
                toExecuteAfterSwipe: toExecuteAfterSwipe,
                onSwipe: onSwipe
            )
        )
    }
}

private struct MultipleTouchSwipeView: ViewModifier {
    let numberOfTouchesRequired: Int
    let direction: UISwipeGestureRecognizer.Direction
    let toExecuteBeforeSwipe: (() -> ())?
    let toExecuteAfterSwipe: (() -> ())?
    let onSwipe: () -> ()
    
    func body(content: Content) -> some View {
        content.overlay {
            SwipeableViewRepresentable(numberOfTouchesRequired: numberOfTouchesRequired,
                                       direction: direction,
                                       toExecuteBeforeSwipe: toExecuteBeforeSwipe,
                                       toExecuteAfterSwipe: toExecuteAfterSwipe) { _ in
                onSwipe()
            }
        }
    }
}

private struct SwipeableViewRepresentable: UIViewRepresentable {
    let numberOfTouchesRequired: Int
    let direction: UISwipeGestureRecognizer.Direction
    let toExecuteBeforeSwipe: (() -> ())?
    let toExecuteAfterSwipe: (() -> ())?
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
        let toExecuteBeforeSwipe: (() -> ())?
        let toExecuteAfterSwipe: (() -> ())?
        let onSwipe: (UISwipeGestureRecognizer) -> Void

        init(toExecuteBeforeSwipe: (() -> ())? = nil,
             toExecuteAfterSwipe: (() -> ())? = nil,
             onSwipe: @escaping (UISwipeGestureRecognizer) -> Void) {
            self.toExecuteBeforeSwipe = toExecuteBeforeSwipe
            self.toExecuteAfterSwipe = toExecuteAfterSwipe
            self.onSwipe = onSwipe
        }

        @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
            self.toExecuteBeforeSwipe?()
            self.onSwipe(sender)
            self.toExecuteAfterSwipe?()
        }
    }
}
