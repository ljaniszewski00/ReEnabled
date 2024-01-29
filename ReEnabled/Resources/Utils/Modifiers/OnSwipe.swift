import SwiftUI

private struct SwipeModifier: ViewModifier {
    let rightToLeftAction: () -> ()
    let leftToRightAction: () -> ()

    func body(content: Content) -> some View {
        content
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    let verticalAmount = value.translation.height
                    
                    guard abs(horizontalAmount) > abs(verticalAmount) else {
                        return
                    }
                    
                    withAnimation {
                        horizontalAmount < 0 ? rightToLeftAction() :  leftToRightAction()
                    }
            })
    }
}

extension View {
    func onSwipe(fromRightToLeft: @escaping () -> (),
                 fromLeftToRight: @escaping () -> ()) -> some View {
        modifier(SwipeModifier(rightToLeftAction: fromRightToLeft,
                               leftToRightAction: fromLeftToRight))
    }
}
