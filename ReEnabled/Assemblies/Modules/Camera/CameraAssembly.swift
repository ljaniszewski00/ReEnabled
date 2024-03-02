import Swinject

class CaptureSessionManagerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CaptureSessionManaging.self) { _ in
            CaptureSessionManager()
        }

        container.register(CaptureDepthSessionManaging.self) { _ in
            CaptureDepthSessionManager()
        }
        
        container.register(FlashlightManaging.self) { _ in
            FlashlightManager()
        }
    }
}
