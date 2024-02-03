import AVFoundation
import SwiftUI
import UIKit
import Vision

class ObjectsRecognizeViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil
    
    private var videoOutput = AVCaptureVideoDataOutput()
    var requests = [VNRequest]()
    var detectionLayer: CALayer! = nil
    
    private let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput",
                                                     qos: .userInitiated,
                                                     attributes: [],
                                                     autoreleaseFrequency: .workItem)
    
    override func viewDidLoad() {
        checkPermission()
        
        captureSessionQueue.async { [unowned self] in
            guard permissionGranted else {
                return
            }
            
            self.setupCaptureSession()
            
            self.setupLayers()
            self.setupDetector()
            
            startCaptureSession()
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
        
        updateLayers()
    }
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    private func requestPermission() {
        captureSessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
            self.captureSessionQueue.resume()
        }
    }
    
    private func setupCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInLiDARDepthCamera,
                                                        for: .video,
                                                        position: .back) else {
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .vga640x480
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput) else {
            captureSession.commitConfiguration()
            return
        }

        captureSession.addInput(videoDeviceInput)
                         
        screenRect = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, 
                                    y: 0,
                                    width: screenRect.size.width,
                                    height: screenRect.size.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill screen
        previewLayer.connection?.videoOrientation = .portrait
        
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        videoOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        let captureConnection = videoOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        
        do {
            try videoDevice.lockForConfiguration()
            videoDevice.unlockForConfiguration()
        } catch {
            
        }
        
        captureSession.addOutput(videoOutput)
        
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        captureSession.commitConfiguration()
        
        DispatchQueue.main.async { [weak self] in
            self?.view.layer.addSublayer(self!.previewLayer)
        }
    }
    
    private func startCaptureSession() {
        captureSession.startRunning()
    }
    
    private func stopCaptureSession() {
        captureSession.stopRunning()
    }
}

extension ObjectsRecognizeViewController {
    func setupDetector() {
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3Int8LUT", 
                                             withExtension: "mlmodelc") else {
            return
        }
    
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch let error {
            
        }
    }
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async(execute: {
            if let results = request.results {
                self.extractDetections(results)
            }
        })
    }
    
    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
            
            // Transformations
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox,
                                                            Int(screenRect.size.width),
                                                            Int(screenRect.size.height))
            
            let transformedBounds = CGRect(x: objectBounds.minX,
                                           y: screenRect.size.height - objectBounds.maxY,
                                           width: objectBounds.maxX - objectBounds.minX,
                                           height: objectBounds.maxY - objectBounds.minY)
            
            let boxLayer = self.createBoundingBoxIn(transformedBounds)
            let textLayer = self.createTextSubLayerIn(objectBounds,
                                                      identifier: objectObservation.labels[0].identifier)

            boxLayer.addSublayer(textLayer)
            detectionLayer.addSublayer(boxLayer)
            self.view.layer.addSublayer(detectionLayer)
        }
    }
    
    func setupLayers() {
        detectionLayer = CALayer()
        detectionLayer.frame = CGRect(x: 0,
                                      y: 0,
                                      width: screenRect.size.width,
                                      height: screenRect.size.height)
        self.view.layer.addSublayer(detectionLayer)
    }
    
    func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0,
                                       y: 0,
                                       width: screenRect.size.width,
                                       height: screenRect.size.height)
    }
    
    private func createTextSubLayerIn(_ bounds: CGRect, identifier: String) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        let formattedIdentifierString = NSMutableAttributedString(string: String(format: "\(identifier)", identifier))
        let largeFont = UIFont(name: "Helvetica",
                               size: 24.0)!
        
        formattedIdentifierString.addAttributes([NSAttributedString.Key.font: largeFont,
                                                 NSAttributedString.Key.foregroundColor: UIColor.yellow],
                                                range: NSRange(location: 0,
                                                               length: identifier.count))
        
        textLayer.string = formattedIdentifierString
        
        textLayer.bounds = CGRect(x: 0,
                                  y: 0,
                                  width: bounds.size.height - 10,
                                  height: bounds.size.width - 10)
        textLayer.position = CGPoint(x: bounds.midX - 5,
                                     y: bounds.midY - 5)
        textLayer.shadowOpacity = 0.7
        textLayer.shadowOffset = CGSize(width: 2,
                                        height: 2)
        return textLayer
    }
    
    private func createBoundingBoxIn(_ bounds: CGRect) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = UIColor.yellow.cgColor
        boxLayer.cornerRadius = 4
        return boxLayer
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:]) // Create handler to perform request on the buffer

        do {
            try imageRequestHandler.perform(self.requests) // Schedules vision requests to be performed
        } catch {
            
        }
    }
}

