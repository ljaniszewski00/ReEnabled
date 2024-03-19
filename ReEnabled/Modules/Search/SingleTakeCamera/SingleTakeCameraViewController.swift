import AVKit
import UIKit

class SingleTakeCameraViewController: UIViewController {
    private var singleTakeCameraManager: SingleTakeCameraManager = SingleTakeCameraManager()
    private var searchViewModel: SearchViewModel?

    private var screenRect: CGRect = UIScreen.main.bounds
    private var previewLayer = AVCaptureVideoPreviewLayer()
    
    var photoCaptureCompletionBlock: ((UIImage?) -> Void)?
    
    init(searchViewModel: SearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.searchViewModel = searchViewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.searchViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleTakeCameraManager.setUp {
            self.setupUI()
        }
    }
    
    private func setupUI() {
        setSessionPreviewLayer()
    }
    
    private func setSessionPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: singleTakeCameraManager.captureSession)
        previewLayer.frame = CGRect(x: 0,
                                    y: 0,
                                    width: screenRect.size.width,
                                    height: screenRect.size.height)
        previewLayer.videoGravity = .resizeAspectFill
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.view.layer.addSublayer(self.previewLayer)
            
            self.captureImage { [weak self] image in
                self?.searchViewModel?.selectedImage = image
                self?.searchViewModel?.showCamera = false
            }
        }
    }
    
    func captureImage(completion: @escaping ((UIImage?) -> Void)) {
        guard singleTakeCameraManager.captureSession.isRunning else {
            return
        }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = singleTakeCameraManager.flashMode
        
        self.singleTakeCameraManager.photoOutput.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
}

extension SingleTakeCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: (any Error)?) {
        guard let fileData = photo.fileDataRepresentation(),
              let uiImage: UIImage = UIImage(data: fileData) else {
            return
        }
        
        self.photoCaptureCompletionBlock?(uiImage)
    }
}
