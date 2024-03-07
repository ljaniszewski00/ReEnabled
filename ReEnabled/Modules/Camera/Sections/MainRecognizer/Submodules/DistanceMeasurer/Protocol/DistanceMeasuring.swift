import AVFoundation

protocol DistanceMeasuring {
    func getDepthValueFromFrame(fromFrame: CVPixelBuffer, 
                                atPoint: CGPoint) -> Float
}
