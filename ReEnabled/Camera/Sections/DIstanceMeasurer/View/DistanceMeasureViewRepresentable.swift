import ARKit
import RealityKit
import SwiftUI

struct DistanceMeasureViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        
        arView.session.delegate = context.coordinator
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> ARSessionDelegateCoordinator {
        ARSessionDelegateCoordinator()
    }
}

class ARSessionDelegateCoordinator: NSObject, ARSessionDelegate {
    private let distanceMeasureViewModel: DistanceMeasureViewModel = .shared
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let currentPointCloud = frame.rawFeaturePoints else {
            return
        }
        
        let cameraTransform = frame.camera.transform
        
        var closestDistance: Float = Float.greatestFiniteMagnitude
        
        for point in currentPointCloud.points {
            let pointInCameraSpace = cameraTransform.inverse * simd_float4(point, 1)
            let distanceToCamera = sqrt(
                pointInCameraSpace.x * pointInCameraSpace.x +
                pointInCameraSpace.y * pointInCameraSpace.y +
                pointInCameraSpace.z * pointInCameraSpace.z
            )
            
            if distanceToCamera < closestDistance {
                closestDistance = distanceToCamera
            }
        }
        
        distanceMeasureViewModel.distance = closestDistance
    }
}
