import Swinject

class CaptureSessionManagerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CaptureSessionManaging.self) { _ in
            CaptureSessionManager()
        }
        
        container.register(FlashlightManaging.self) { _ in
            FlashlightManager()
        }
    }
}
