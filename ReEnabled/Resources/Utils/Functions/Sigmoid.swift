import Foundation

/**
 Logistic sigmoid.
 */
public func sigmoid(_ x: Float) -> Float {
    return 1 / (1 + exp(-x))
}
