import AVFoundation
import UIKit

extension CMSampleBuffer {
    func convertToPixelBuffer() -> CVPixelBuffer? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(self) else {
            return nil
        }
        
        let cameraImage = CIImage(cvImageBuffer: imageBuffer)
        
        if let colorMatrixFilter = CIFilter(name: "CIColorMatrix") {
            let r:CGFloat = 1
            let g:CGFloat = 1
            let b:CGFloat = 0
            let a:CGFloat = 1
            
            colorMatrixFilter.setDefaults()
            colorMatrixFilter.setValue(cameraImage, forKey: "inputImage")
            colorMatrixFilter.setValue(CIVector(x: r, y: 0, z: 0, w: 0),
                                       forKey: "inputRVector")
            colorMatrixFilter.setValue(CIVector(x: 0, y: g, z: 0, w: 0),
                                       forKey: "inputGVector")
            colorMatrixFilter.setValue(CIVector(x: 0, y: 0, z: b, w: 0),
                                       forKey: "inputBVector")
            colorMatrixFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: a),
                                       forKey: "inputAVector")
            
            if let ciimage = colorMatrixFilter.outputImage {
                CIContext().render(ciimage, to: imageBuffer)
                return imageBuffer
            }
        }
        
        return nil
    }
}
