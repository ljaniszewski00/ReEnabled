import UIKit
import AVFoundation

class ColorDetectorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let colorDetectorViewModel: ColorDetectorViewModel = .shared
    private let captureSessionManager: CaptureSessionManager = .shared
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    private let center: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2 - 15,
                                          y: UIScreen.main.bounds.height / 2 - 15)
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionManager.setUp(with: self, for: .colorDetector) {
            self.setupUI()
            DispatchQueue.main.async {
                self.colorDetectorViewModel.canDisplayCamera = true
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        guard let baseAddr = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0) else {
            return
        }
        let width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0)
        let height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bimapInfo: CGBitmapInfo = [
            .byteOrder32Little,
            CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)]
        
        guard let content = CGContext(data: baseAddr, 
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bimapInfo.rawValue),
              let cgImage = content.makeImage() else {
            return
        }
        
        DispatchQueue.main.async {
            self.previewLayer.contents = cgImage
            let color = self.previewLayer.pickColor(at: self.center)
            self.view.backgroundColor = color
            self.colorDetectorViewModel.detectedColor = color
        }
    }
    
    private func setupUI() {
        setSessionPreviewLayer()
        createOuterDetectorFrame()
        createInnerDetectorFrame()
    }
    
    private func setSessionPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSessionManager.captureSession)
        previewLayer.frame = CGRect(x: 0,
                                    y: 0,
                                    width: screenWidth - 30,
                                    height: screenHeight - 30)
        previewLayer.position = self.view.center
        previewLayer.contentsGravity = .resizeAspectFill
        previewLayer.masksToBounds = true
        previewLayer.setAffineTransform(
            CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0))
        )
        self.view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    private func createOuterDetectorFrame() {
        let linePath = UIBezierPath.init(
            ovalIn: CGRect.init(x: 0,
                                y: 0,
                                width: 40,
                                height: 40)
        )
        let lineShape = CAShapeLayer()
        lineShape.frame = CGRect.init(x: screenWidth / 2 - 20,
                                      y: screenHeight / 2 - 20,
                                      width: 40,
                                      height: 40)
        lineShape.lineWidth = 5
        lineShape.strokeColor = UIColor.red.cgColor
        lineShape.path = linePath.cgPath
        lineShape.fillColor = UIColor.clear.cgColor
        self.view.layer.insertSublayer(lineShape, at: 1)
    }
    
    private func createInnerDetectorFrame() {
        let linePath = UIBezierPath.init(ovalIn: CGRect.init(x: 0,
                                                             y: 0,
                                                             width: 8,
                                                             height: 8))
        let lineShape = CAShapeLayer()
        lineShape.frame = CGRect.init(x: screenWidth / 2 - 4,
                                      y: screenHeight / 2 - 4,
                                      width: 8,
                                      height: 8)
        lineShape.path = linePath.cgPath
        lineShape.fillColor = UIColor.init(white: 0.7, alpha: 0.5).cgColor
        self.view.layer.insertSublayer(lineShape, at: 1)
    }
}
