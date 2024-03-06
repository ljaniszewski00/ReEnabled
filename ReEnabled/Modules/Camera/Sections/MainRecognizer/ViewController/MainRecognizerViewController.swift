import AVFoundation
import SwiftUI
import UIKit
import Vision

class MainRecognizerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Inject private var captureSessionManager: CaptureSessionManaging
    
    internal var objectsRecognizerViewModel: ObjectsRecognizerViewModel?
    internal var distanceMeasurerViewModel: DistanceMeasureViewModel?
    internal var roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel?
    internal var pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel?
    
    internal var previewLayer = AVCaptureVideoPreviewLayer()
    private var screenRect: CGRect! = nil
    
    // MARK: - ObjectsRecognizer Properties
    
    // How many predictions we can do concurrently.
    internal let objectModel: ObjectModel = ObjectModel()
    
    internal var objectsBoundingBoxes = [ObjectBoundingBox]()
    internal var objectsBoundingBoxesColors: [UIColor] = []
    
    internal let ciContext = CIContext()
    
    static let maxInflightBuffers = 3
    internal var inflightBuffer = 0
    internal let objectsRecognizerSemaphore = DispatchSemaphore(value: maxInflightBuffers)
    
    // MARK: - DistanceMeasurer Properties
    
    
    
    // MARK: - RoadLightsRecognizer Properties
    
    
    
    // MARK: - PedestrianCrossingRecognizer Properties
    
    
    internal var objectsRecognizerRequests = [VNRequest]()
    internal var roadLightsRecognizerRequests = [VNRequest]()
    internal var pedestrianCrossingRecognizerRequests = [VNRequest]()
    
    init(objectsRecognizerViewModel: ObjectsRecognizerViewModel,
         distanceMeasurerViewModel: DistanceMeasureViewModel,
         roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel,
         pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.objectsRecognizerViewModel = objectsRecognizerViewModel
        self.distanceMeasurerViewModel = distanceMeasurerViewModel
        self.roadLightsRecognizerViewModel = roadLightsRecognizerViewModel
        self.pedestrianCrossingRecognizerViewModel = pedestrianCrossingRecognizerViewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.objectsRecognizerViewModel = nil
        self.distanceMeasurerViewModel = nil
        self.roadLightsRecognizerViewModel = nil
        self.pedestrianCrossingRecognizerViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObjectsRecognizer()
        
        captureSessionManager.setUp(with: self,
                                    for: .mainRecognizer,
                                    cameraPosition: .back,
                                    desiredFrameRate: 20) {
            self.setupSessionPreviewLayer()
            
            self.setupBoundingBoxes()
            
            DispatchQueue.main.async {
                
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRect = UIScreen.main.bounds
        self.previewLayer.frame = CGRect(x: 0,
                                         y: 0,
                                         width: screenRect.size.width,
                                         height: screenRect.size.height)

        switch UIDevice.current.orientation {
        case UIDeviceOrientation.portraitUpsideDown:
            self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case UIDeviceOrientation.landscapeLeft:
            self.previewLayer.connection?.videoOrientation = .landscapeRight
        case UIDeviceOrientation.landscapeRight:
            self.previewLayer.connection?.videoOrientation = .landscapeLeft
        case UIDeviceOrientation.portrait:
            self.previewLayer.connection?.videoOrientation = .portrait
        default:
            break
        }
    }
    
    private func setupSessionPreviewLayer() {
        screenRect = UIScreen.main.bounds
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
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(for: sampleBuffer, force: nil)
        }
        
        guard let cvPixelBuffer = sampleBuffer.convertToPixelBuffer() else {
            return
        }
        
        manageCaptureOutputForObjectsRecognizer(pixelBuffer: cvPixelBuffer)
    }
}


