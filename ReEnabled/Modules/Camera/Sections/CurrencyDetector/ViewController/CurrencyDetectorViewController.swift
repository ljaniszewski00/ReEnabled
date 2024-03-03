import AVFoundation
import SwiftUI
import UIKit
import Vision

class CurrencyDetectorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Inject private var captureSessionManager: CaptureSessionManaging
    private var currencyDetectorViewModel: CurrencyDetectorViewModel?
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil
    
    var requests = [VNRequest]()
    var detectionLayer: CALayer! = nil
    
    init(currencyDetectorViewModel: CurrencyDetectorViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.currencyDetectorViewModel = currencyDetectorViewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.currencyDetectorViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionManager.setUp(with: self, 
                                    for: .objectRecognizer,
                                    cameraPosition: .back,
                                    desiredFrameRate: 30) {
            self.setupSessionPreviewLayer()
            self.setupDetector()
            DispatchQueue.main.async {
                self.currencyDetectorViewModel?.canDisplayCamera = true
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
}

extension CurrencyDetectorViewController {
    func setupDetector() {
        guard let modelURL = Bundle.main.url(forResource: MLModelFile.currencyDetector.fileName,
                                             withExtension: "mlmodelc") else {
            return
        }
    
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch {
            return
        }
    }
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            print("DETECTION DID COMPLETE")
            
            guard let results = request.results else {
                return
            }
            
            print("RESULTS EXIST")
            
            for observation in results {
                guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
                
                print("OBSERVATION IS VNRecognizedObjectObservation")
                
                print(objectObservation.labels[0].identifier)
                self.currencyDetectorViewModel?.detectedCurrency = objectObservation.labels[0].identifier
            }
            
            print()
            
//            for currentObservation in results {
//                let topCandidate = currentObservation.topCandidates(1)
//                if let topCandidateFirstObservation = topCandidate.first {
//                    print(topCandidateFirstObservation.string)
//                    self.currencyDetectorViewModel.detectedCurrency = topCandidateFirstObservation.string
//                }
//            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(for: sampleBuffer, force: nil)
        }
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation)

        do {
            try handler.perform(self.requests)
        } catch {
            return
        }
    }
}
