import Accelerate
import AVFoundation
import UIKit

class DistanceMeasureViewController: UIViewController, AVCaptureDepthDataOutputDelegate {
    @Inject private var captureDepthSessionManager: CaptureDepthSessionManaging
    private var distanceMeasureViewModel: DistanceMeasurerViewModel?
    
    private var screenRect: CGRect = UIScreen.main.bounds
    private var previewLayer = AVCaptureVideoPreviewLayer()
    
    private let depthDataOutput = AVCaptureDepthDataOutput()
    
    private let depthMeasurementRepeats = 10
    private var depthMeasurementsLeftInLoop = 0
    private var depthMeasurementsCumul: Float32 = 0.0
    private var depthMeasurementMin: Float32 = 0.0
    private var depthMeasurementMax: Float32 = 0.0
    
    init(distanceMeasureViewModel: DistanceMeasurerViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.distanceMeasureViewModel = distanceMeasureViewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.distanceMeasureViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureDepthSessionManager.setUp(with: depthDataOutput,
                                         and: self,
                                         cameraPosition: .back) {
            self.setupUI()
            DispatchQueue.main.async {
                self.distanceMeasureViewModel?.canDisplayCamera = true
            }
        }
    }
    
    func depthDataOutput(_ output: AVCaptureDepthDataOutput, didOutput depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {
        if depthMeasurementsLeftInLoop == 0 {
            depthMeasurementsCumul = 0.0
            depthMeasurementMin = 9999.9
            depthMeasurementMax = 0.0
            depthMeasurementsLeftInLoop = depthMeasurementRepeats
        }
        
        if depthMeasurementsLeftInLoop > 0 {
            let depthFrame = depthData.depthDataMap
            let depthPoint = CGPoint(x: CGFloat(CVPixelBufferGetWidth(depthFrame)) / 2,
                                     y: CGFloat(CVPixelBufferGetHeight(depthFrame) / 2))
            let depthVal = getDepthValueFromFrame(fromFrame: depthFrame, atPoint: depthPoint)
            let measurement = depthVal * 100
            
            depthMeasurementsCumul += measurement
            
            if measurement > depthMeasurementMax {
                depthMeasurementMax = measurement
            }
            
            if measurement < depthMeasurementMin {
                depthMeasurementMin = measurement
            }
            
            depthMeasurementsLeftInLoop -= 1
            
//            let printStr = String(format: "Measurement %d: %.2f cm",
//                depthMeasurementRepeats - depthMeasurementsLeftInLoop, measurement)
            
            DispatchQueue.main.async { [weak self] in
                print(String(format: "%.2f", measurement))
                self?.distanceMeasureViewModel?.distanceString = String(format: "%.2f", measurement)
            }
        }
    }
        
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
    
    private func setupUI() {
        setSessionPreviewLayer()
    }
    
    private func setSessionPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureDepthSessionManager.captureSession)
        previewLayer.frame = CGRect(x: 0,
                                    y: 0,
                                    width: screenRect.size.width,
                                    height: screenRect.size.height)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.view.layer.addSublayer(self.previewLayer)
        }
    }
}
