import Foundation

protocol Prediction {
    var classIndex: Int { get }
    var score: Float { get }
    var rect: CGRect { get }
}
