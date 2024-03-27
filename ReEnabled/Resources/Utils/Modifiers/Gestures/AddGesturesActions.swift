import SwiftUI

extension View {
    func addGesturesActions(toExecuteBeforeEveryAction: @escaping () -> (),
                            toExecuteAfterEveryAction: @escaping () -> (),
                            onTap: @escaping () -> (),
                            onDoubleTap: @escaping () -> (),
                            onLongPress: @escaping () -> (),
                            onSwipeFromLeftToRight: @escaping () -> (),
                            onSwipeFromRightToLeft: @escaping () -> (),
                            onSwipeFromUpToDown: @escaping () -> (),
                            onSwipeFromDownToUp: @escaping () -> (),
                            onSwipeFromLeftToRightAfterLongPress: @escaping () -> (),
                            onSwipeFromRightToLeftAfterLongPress: @escaping () -> (),
                            onSwipeFromUpToDownAfterLongPress: @escaping () -> (),
                            onSwipeFromDownToUpAfterLongPress: @escaping () -> ()) -> some View {
        modifier(GestureActionView(toExecuteBeforeEveryAction: toExecuteBeforeEveryAction,
                                   toExecuteAfterEveryAction: toExecuteAfterEveryAction,
                                   onTap: onTap,
                                   onDoubleTap: onDoubleTap,
                                   onLongPress: onLongPress,
                                   onSwipeFromLeftToRight: onSwipeFromLeftToRight,
                                   onSwipeFromRightToLeft: onSwipeFromRightToLeft,
                                   onSwipeFromUpToDown: onSwipeFromUpToDown,
                                   onSwipeFromDownToUp: onSwipeFromDownToUp,
                                   onSwipeFromLeftToRightAfterLongPress: onSwipeFromLeftToRightAfterLongPress,
                                   onSwipeFromRightToLeftAfterLongPress: onSwipeFromRightToLeftAfterLongPress,
                                   onSwipeFromUpToDownAfterLongPress: onSwipeFromUpToDownAfterLongPress,
                                   onSwipeFromDownToUpAfterLongPress: onSwipeFromDownToUpAfterLongPress))
    }
}

private struct GestureActionView: ViewModifier {
    let toExecuteBeforeEveryAction: (() -> ())?
    let toExecuteAfterEveryAction: (() -> ())?
    let onTap: (() -> ())?
    let onDoubleTap: (() -> ())?
    let onLongPress: (() -> ())?
    let onSwipeFromLeftToRight: (() -> ())?
    let onSwipeFromRightToLeft: (() -> ())?
    let onSwipeFromUpToDown: (() -> ())?
    let onSwipeFromDownToUp: (() -> ())?
    let onSwipeFromLeftToRightAfterLongPress: (() -> ())?
    let onSwipeFromRightToLeftAfterLongPress: (() -> ())?
    let onSwipeFromUpToDownAfterLongPress: (() -> ())?
    let onSwipeFromDownToUpAfterLongPress: (() -> ())?

    func body(content: Content) -> some View {
        let tapGesture = TapGesture()
            .onEnded {
                withAnimation {
                    toExecuteBeforeEveryAction?()
                    onTap?()
                    toExecuteAfterEveryAction?()
                }
            }
        
        let doubleTapGesture = TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    toExecuteBeforeEveryAction?()
                    onDoubleTap?()
                    toExecuteAfterEveryAction?()
                }
            }
        
        let longPressGesture = LongPressGesture(minimumDuration: 1.5, maximumDistance: 3)
            .onEnded { _ in
                withAnimation {
                    toExecuteBeforeEveryAction?()
                    onLongPress?()
                    toExecuteAfterEveryAction?()
                }
            }
        
        let swipeGesture = DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onEnded { value in
                let horizontalAmount = value.translation.width
                let verticalAmount = value.translation.height
                
                if abs(horizontalAmount) > abs(verticalAmount) {
                    withAnimation {
                        toExecuteBeforeEveryAction?()
                        horizontalAmount < 0 ? onSwipeFromRightToLeft?() :  onSwipeFromLeftToRight?()
                        toExecuteAfterEveryAction?()
                    }
                } else {
                    withAnimation {
                        toExecuteBeforeEveryAction?()
                        verticalAmount < 0 ? onSwipeFromDownToUp?() :  onSwipeFromUpToDown?()
                        toExecuteAfterEveryAction?()
                    }
                }
        }
        
        let longPressGestureToDrag = LongPressGesture()
        let swipeAfterLongPressGesture = DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onEnded { value in
                let horizontalAmount = value.translation.width
                let verticalAmount = value.translation.height
                
                if abs(horizontalAmount) > abs(verticalAmount) {
                    withAnimation {
                        toExecuteBeforeEveryAction?()
                        horizontalAmount < 0 ? onSwipeFromRightToLeftAfterLongPress?() :  onSwipeFromLeftToRightAfterLongPress?()
                        toExecuteAfterEveryAction?()
                    }
                } else {
                    withAnimation {
                        toExecuteBeforeEveryAction?()
                        verticalAmount < 0 ? onSwipeFromDownToUpAfterLongPress?() :  onSwipeFromUpToDownAfterLongPress?()
                        toExecuteAfterEveryAction?()
                    }
                }
            }
        
        let sequenceGesture = SequenceGesture(longPressGestureToDrag, swipeAfterLongPressGesture)
        
        // Order matters!
        content
            .gesture(doubleTapGesture)
            .gesture(tapGesture)
            .gesture(sequenceGesture)
            .gesture(longPressGesture)
            .gesture(swipeGesture)
    }
}
