import Accelerate
import AVFoundation
import SwiftUI
import UIKit
import Vision

extension MainRecognizerViewController: DistanceMeasuring {
    func getDepthValueFromFrame(fromFrame: CVPixelBuffer, atPoint: CGPoint) -> Float {
        assert(kCVPixelFormatType_DepthFloat16 == CVPixelBufferGetPixelFormatType(fromFrame))
        CVPixelBufferLockBaseAddress(fromFrame, .readOnly)
        let rowData = CVPixelBufferGetBaseAddress(fromFrame)! + Int(atPoint.y) * CVPixelBufferGetBytesPerRow(fromFrame)
        var f16Pixel = rowData.assumingMemoryBound(to: UInt16.self)[Int(atPoint.x)]
        var f32Pixel = Float(0.0)
        
        CVPixelBufferUnlockBaseAddress(fromFrame, .readOnly)
        withUnsafeMutablePointer(to: &f16Pixel) { f16RawPointer in
            withUnsafeMutablePointer(to: &f32Pixel) { f32RawPointer in
                var src = vImage_Buffer(data: f16RawPointer,
                                        height: 1,
                                        width: 1,
                                        rowBytes: 2)
                var dst = vImage_Buffer(data: f32RawPointer,
                                        height: 1,
                                        width: 1,
                                        rowBytes: 4)
                vImageConvert_Planar16FtoPlanarF(&src,
                                                 &dst, 0)
            }
        }
        
        return f32Pixel
    }
}
