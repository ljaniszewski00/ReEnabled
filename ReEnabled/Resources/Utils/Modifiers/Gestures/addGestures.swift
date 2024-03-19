import SwiftUI

extension View {
    func addGesturesActions(onTap: @escaping () -> (),
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
        modifier(GestureActionView(onTap: onTap,
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
    
    @State private var longPressed: Bool = false
    @State private var isDragging = false

    func body(content: Content) -> some View {
        let tapGesture = TapGesture()
            .onEnded {
                withAnimation {
                    onTap?()
                }
            }
        
        let doubleTapGesture = TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    onDoubleTap?()
                }
            }
        
        let longPressGesture = LongPressGesture(minimumDuration: 1.5, maximumDistance: 3)
            .onEnded { _ in
                withAnimation {
                    onLongPress?()
                }
            }
        
        let swipeGesture = DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onEnded { value in
                let horizontalAmount = value.translation.width
                let verticalAmount = value.translation.height
                
                if abs(horizontalAmount) > abs(verticalAmount) {
                    withAnimation {
                        horizontalAmount < 0 ? onSwipeFromRightToLeft?() :  onSwipeFromLeftToRight?()
                    }
                } else {
                    withAnimation {
                        verticalAmount < 0 ? onSwipeFromDownToUp?() :  onSwipeFromUpToDown?()
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
                        horizontalAmount < 0 ? onSwipeFromRightToLeftAfterLongPress?() :  onSwipeFromLeftToRightAfterLongPress?()
                    }
                } else {
                    withAnimation {
                        verticalAmount < 0 ? onSwipeFromDownToUpAfterLongPress?() :  onSwipeFromUpToDownAfterLongPress?()
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
