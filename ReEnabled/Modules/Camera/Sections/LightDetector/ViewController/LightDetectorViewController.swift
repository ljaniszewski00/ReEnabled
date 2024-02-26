import UIKit
import AVFoundation

class LightDetectorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Inject private var captureSessionManager: CaptureSessionManaging
    private var lightDetectorViewModel: LightDetectorViewModel?
    
    private var screenRect: CGRect = UIScreen.main.bounds
    private var previewLayer = AVCaptureVideoPreviewLayer()
    
    init(lightDetectorViewModel: LightDetectorViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.lightDetectorViewModel = lightDetectorViewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.lightDetectorViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionManager.setUp(with: self, for: .lightDetector) {
            self.setupUI()
            DispatchQueue.main.async {
                self.lightDetectorViewModel?.canDisplayCamera = true
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let luminosity = CaptureSessionManager.getLuminosityValueFromCamera(with: sampleBuffer) else {
            return
        }
    
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(for: sampleBuffer, force: .off)
            self.lightDetectorViewModel?.luminosity = luminosity
        }
    }
    
    private func setupUI() {
        setSessionPreviewLayer()
    }
    
    private func setSessionPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSessionManager.captureSession)
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
