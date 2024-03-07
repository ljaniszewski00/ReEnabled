import AVFoundation
import SwiftUI
import UIKit
import Vision

class MainRecognizerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Inject var captureSessionManager: CaptureSessionManaging
    
    var objectsRecognizerViewModel: ObjectsRecognizerViewModel?
    var distanceMeasurerViewModel: DistanceMeasureViewModel?
    var roadLightsRecognizerViewModel: RoadLightsRecognizerViewModel?
    var pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel?
    
    var previewLayer = AVCaptureVideoPreviewLayer()
    private var screenRect: CGRect! = nil
    
    // MARK: - ObjectsRecognizer Properties
    
    let objectModel: ObjectModel = ObjectModel()
    var objectsBoundingBoxes = [ObjectBoundingBox]()
    var objectsBoundingBoxesColors: [UIColor] = []
    
    let ciContext = CIContext()
    
    static let maxInflightBuffers = 3
    var inflightBuffer = 0
    let objectsRecognizerSemaphore = DispatchSemaphore(value: maxInflightBuffers)
    
    var objectsRecognizerRequests = [VNRequest]()
    
    // MARK: - DistanceMeasurer Properties
    
    
    
    // MARK: - RoadLightsRecognizer Properties
    
    let roadLightsTypeManager: RoadLightsTypeManager = RoadLightsTypeManager(
        confidenceThreshold: 0,
        maxDetections: RoadLightsModel.maxBoundingBoxes,
        minIOU: 0.3
    )
    
    let roadLightsModel: RoadLightsModel = RoadLightsModel()
    var roadLightsBoundingBoxes = [RoadLightsBoundingBox]()
    var roadLightsBoundingBoxesColors: [UIColor] = []
    
    var roadLightsRecognizerRequests = [VNRequest]()
    
    // MARK: - PedestrianCrossingRecognizer Properties
    
    let pedestrianCrossingModel: PedestrianCrossingModel = PedestrianCrossingModel()
    
    var pedestrianCrossingRecognitionLayer: CALayer! = nil
    
    var pedestrianCrossingRecognizerRequests = [VNRequest]()
    
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
        setupRoadLightsRecognizer()
        setupPedestrianCrossingRecognizer()
        
        captureSessionManager.setUp(with: self,
                                    for: .mainRecognizer,
                                    cameraPosition: .back,
                                    desiredFrameRate: 20) {
            self.setupSessionPreviewLayer()
            
            self.setupObjectsBoundingBoxes()
            self.setupRoadLightsBoundingBoxes()
            self.setupPedestrianCrossingRecognitionLayer()
            self.updatePedestrianCrossingRecognitionLayerGeometry()
            
            DispatchQueue.main.async {
                self.objectsRecognizerViewModel?.canDisplayCamera = true
                self.roadLightsRecognizerViewModel?.canDisplayCamera = true
                self.pedestrianCrossingRecognizerViewModel?.canDisplayCamera = true
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
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        let handler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer,
                                            orientation: exifOrientation)
        
        let objectsRecognitionRequest = prepareVisionRequestForObjectsRecognition(
            pixelBuffer: cvPixelBuffer
        )
        
        DispatchQueue.global().async {
            try? handler.perform([objectsRecognitionRequest])
            try? handler.perform(self.roadLightsRecognizerRequests)
            try? handler.perform(self.pedestrianCrossingRecognizerRequests)
        }
    }
}


