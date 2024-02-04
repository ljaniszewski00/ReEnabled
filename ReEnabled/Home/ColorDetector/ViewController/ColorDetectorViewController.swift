import UIKit
import AVFoundation

class ColorDetectorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let colorDetectorViewModel: ColorDetectorViewModel = .shared
    private let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    private let videoQueue = DispatchQueue(label: "videoQueue")
    private let captureSession = AVCaptureSession()
    private let previewLayer = CALayer()
    
    private var center: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2 - 15,
                                          y: UIScreen.main.bounds.height / 2 - 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        captureSessionQueue.async { [unowned self] in
            setupCaptureSession()
            startCaptureSession()
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
        previewLayer.bounds = CGRect(x: 0,
                                     y: 0,
                                     width: UIScreen.main.bounds.width - 30,
                                     height: UIScreen.main.bounds.height - 30)
        previewLayer.position = view.center
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
        lineShape.frame = CGRect.init(x: UIScreen.main.bounds.width/2-20, 
                                      y: UIScreen.main.bounds.height/2-20,
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
        lineShape.frame = CGRect.init(x: UIScreen.main.bounds.width/2-4, 
                                      y:UIScreen.main.bounds.height/2-4,
                                      width: 8,
                                      height: 8)
        lineShape.path = linePath.cgPath
        lineShape.fillColor = UIColor.init(white: 0.7, alpha: 0.5).cgColor
        self.view.layer.insertSublayer(lineShape, at: 1)
    }
    
    private func setupCaptureSession() {
        self.captureSession.sessionPreset = .hd1280x720
        
        do {
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                            for: .video,
                                                            position: .back) else {
                return
            }
            let captureDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: NSNumber(value: kCMPixelFormat_32BGRA)] as? [String : Any]
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
            
            if self.captureSession.canAddOutput(videoOutput) {
                self.captureSession.addOutput(videoOutput)
            }
            self.captureSession.addInput(captureDeviceInput)
        } catch {
            return
        }
    }
    
    private func startCaptureSession() {
        self.captureSession.startRunning()
    }
}
