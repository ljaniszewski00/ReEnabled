import ARKit
import RealityKit
import SwiftUI

struct DistanceMeasureViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        config.frameSemantics = .sceneDepth
        
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
        
        let depthMap = session.currentFrame?.sceneDepth?.depthMap
        
        let cameraTransform = frame.camera.transform
        
        let cameraPosition = cameraTransform.columns.3
        let cameraSimd = simd_float3(x: cameraPosition.x,
                                     y: cameraPosition.y,
                                     z: cameraPosition.z)
        
        var closestDistance: Float = Float.greatestFiniteMagnitude
        
        for point in currentPointCloud.points {
            // first approach
//            let pointInCameraSpace = cameraTransform.inverse * simd_float4(point, 1)
//            let distanceToCamera = sqrt(
//                pointInCameraSpace.x * pointInCameraSpace.x +
//                pointInCameraSpace.y * pointInCameraSpace.y +
//                pointInCameraSpace.z * pointInCameraSpace.z
//            )
            
            // second approach
//            let distanceToCamera = distance(point, cameraSimd)
            
            // third approach
            let distanceToCamera = calculateDistanceBetween(cameraSimd, and: point)
            
            if distanceToCamera < closestDistance {
                closestDistance = distanceToCamera
            }
        }
        
        distanceMeasureViewModel.distance = closestDistance
    }
    
    private func calculateDistanceBetween(_ firstPoint: SIMD3<Float>, and secondPoint: SIMD3<Float>) -> Float {
        let a = firstPoint.x - secondPoint.x
        let b = firstPoint.y - secondPoint.y
        let c = firstPoint.z - secondPoint.z
        
        var distance = sqrt(
            pow(a, 2) + pow(b, 2) + pow(c, 2)
        )
        
        return distance
    }
}
