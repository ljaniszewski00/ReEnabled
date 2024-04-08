import SwiftUI

extension View {
    func addGesturesActions(toExecuteBeforeEveryAction: (() -> ())? = nil,
                            toExecuteAfterEveryAction: (() -> ())? = nil,
                            onTap: (() -> ())? = nil,
                            onDoubleTap: (() -> ())? = nil,
                            onTrippleTap: (() -> ())? = nil,
                            onLongPress: (() -> ())? = nil,
                            onSwipeFromLeftToRight: (() -> ())? = nil,
                            onSwipeFromRightToLeft: (() -> ())? = nil,
                            onSwipeFromUpToDown: (() -> ())? = nil,
                            onSwipeFromDownToUp: (() -> ())? = nil,
                            onSwipeFromLeftToRightAfterLongPress: (() -> ())? = nil,
                            onSwipeFromRightToLeftAfterLongPress: (() -> ())? = nil,
                            onSwipeFromUpToDownAfterLongPress: (() -> ())? = nil,
                            onSwipeFromDownToUpAfterLongPress: (() -> ())? = nil) -> some View {
        modifier(GestureActionView(toExecuteBeforeEveryAction: toExecuteBeforeEveryAction,
                                   toExecuteAfterEveryAction: toExecuteAfterEveryAction,
                                   onTap: onTap,
                                   onDoubleTap: onDoubleTap,
                                   onTrippleTap: onTrippleTap,
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
    let onTrippleTap: (() -> ())?
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
                    if let onTap = onTap {
                        toExecuteBeforeEveryAction?()
                        onTap()
                        toExecuteAfterEveryAction?()
                    }
                }
            }
        
        let multiTapGestures = SimultaneousGesture(TapGesture(count: 2), TapGesture(count: 3))
            .onEnded { gestureValue in
                withAnimation {
                    toExecuteBeforeEveryAction?()
                    if gestureValue.first != nil,
                       let onDoubleTap = onDoubleTap {
                        onDoubleTap()
                    }
                    if gestureValue.second != nil,
                       let onTrippleTap = onTrippleTap {
                        onTrippleTap()
                    }
                    toExecuteAfterEveryAction?()
                }
            }
        
        let longPressGesture = LongPressGesture(minimumDuration: 1, maximumDistance: 3)
            .onEnded { _ in
                withAnimation {
                    if let onLongPress = onLongPress {
                        toExecuteBeforeEveryAction?()
                        onLongPress()
                        toExecuteAfterEveryAction?()
                    }
                }
            }
        
        let swipeGesture = DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onEnded { value in
                let horizontalAmount = value.translation.width
                let verticalAmount = value.translation.height
                
                if abs(horizontalAmount) > abs(verticalAmount) {
                    withAnimation {
                        if horizontalAmount < 0 {
                            if let onSwipeFromRightToLeft = onSwipeFromRightToLeft {
                                toExecuteBeforeEveryAction?()
                                onSwipeFromRightToLeft()
                                toExecuteAfterEveryAction?()
                            }
                        } else {
                            if let onSwipeFromLeftToRight = onSwipeFromLeftToRight {
                                toExecuteBeforeEveryAction?()
                                onSwipeFromLeftToRight()
                                toExecuteAfterEveryAction?()
                            }
                        }
                    }
                } else {
                    withAnimation {
                        if verticalAmount < 0 {
                            if let onSwipeFromDownToUp = onSwipeFromDownToUp {
                                toExecuteBeforeEveryAction?()
                                onSwipeFromDownToUp()
                                toExecuteAfterEveryAction?()
                            }
                        } else {
                            if let onSwipeFromUpToDown = onSwipeFromUpToDown {
                                toExecuteBeforeEveryAction?()
                                onSwipeFromUpToDown()
                                toExecuteAfterEveryAction?()
                            }
                        }
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
                        if horizontalAmount < 0 {
                            if let onSwipeFromRightToLeftAfterLongPress = onSwipeFromRightToLeftAfterLongPress {
                                toExecuteBeforeEveryAction?()
                                onSwipeFromRightToLeftAfterLongPress()
                                toExecuteAfterEveryAction?()
                            }
                        } else {
                            if let onSwipeFromLeftToRightAfterLongPress = onSwipeFromLeftToRightAfterLongPress {
                                toExecuteBeforeEveryAction?()
                                onSwipeFromLeftToRightAfterLongPress()
                                toExecuteAfterEveryAction?()
                            }
                        }
                    }
                } else {
                    withAnimation {
                        if verticalAmount < 0 {
                            if let onSwipeFromDownToUpAfterLongPress = onSwipeFromDownToUpAfterLongPress {
                                toExecuteBeforeEveryAction?()
                                onSwipeFromDownToUpAfterLongPress()
                                toExecuteAfterEveryAction?()
                            }
                        } else {
                            if let onSwipeFromUpToDownAfterLongPress = onSwipeFromUpToDownAfterLongPress {
                                toExecuteBeforeEveryAction?()
                                onSwipeFromUpToDownAfterLongPress()
                                toExecuteAfterEveryAction?()
                            }
                        }
                    }
                }
            }
        
        let swipeAfterLongPressSequenceGesture = SequenceGesture(longPressGestureToDrag, swipeAfterLongPressGesture)
        
        // Order matters!
        content
            .gesture(multiTapGestures)
            .gesture(tapGesture)
            .gesture(swipeAfterLongPressSequenceGesture)
            .gesture(longPressGesture)
            .gesture(swipeGesture)
    }
}
