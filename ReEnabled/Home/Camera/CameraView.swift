import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    @EnvironmentObject var cameraViewModel: CameraViewModel
    
    var size: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let capturePreviewLayer = setupCapturePreview()
        view.layer.addSublayer(capturePreviewLayer)
        DispatchQueue.main.async {
            cameraViewModel.rootLayer = view.layer
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if cameraViewModel.rootLayerUpdated {
            uiView.layer.addSublayer(cameraViewModel.rootLayer)
        }
    }
    
    private func setupCapturePreview() -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraViewModel.captureSession)
        previewLayer.frame.size = size
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }
}
