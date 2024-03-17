import Swinject

class CameraAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CaptureSessionManaging.self) { _ in
            CaptureSessionManager()
        }
        
        container.register(FlashlightManaging.self) { _ in
            FlashlightManager()
        }
    }
}
