import AVFoundation
import SwiftUI

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var rootLayer: CALayer! = nil
    @Published var rootLayerUpdated: Bool = false
    @Published var bufferSize: CGSize = .zero
    @Published var captureSession = AVCaptureSession()
    @Published var captureOutput = AVCaptureVideoDataOutput()
    
    @Published var isCaptureSessionCommited: Bool = false
    
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput",
                                                     qos: .userInitiated,
                                                     attributes: [],
                                                     autoreleaseFrequency: .workItem)
    
    func onAppear() {
        checkPermission { [weak self] permissionGranted in
            if permissionGranted {
                self?.setupAV()
            }
        }
    }
    
    private func checkPermission(completion: @escaping ((Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return completion(true)
        case .denied:
            return completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                return completion(status)
            }
        case .restricted:
            return completion(false)
        @unknown default:
            return completion(false)
        }
    }
    
    func setupAV() {
        var deviceInput: AVCaptureDeviceInput!
        
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], 
                                                           mediaType: .video,
                                                           position: .back).devices.first
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .vga640x480
        
        guard captureSession.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.addInput(deviceInput)
        
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
            // Add a video data output
            captureOutput.alwaysDiscardsLateVideoFrames = true
            captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            captureOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            captureSession.commitConfiguration()
            return
        }
        
        let captureConnection = captureOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        
        do {
            try videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            
            DispatchQueue.main.async { [weak self] in
                self?.bufferSize.width = CGFloat(dimensions.width)
                self?.bufferSize.height = CGFloat(dimensions.height)
            }
            
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        captureSession.commitConfiguration()
        isCaptureSessionCommited = true
    }
}
