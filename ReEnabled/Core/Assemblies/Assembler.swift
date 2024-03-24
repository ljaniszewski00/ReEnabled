import Swinject

extension Assembler {
    static var `default`: Assembler {
        get {
            if assembler == nil {
                assembler = buildAssembler()
            }
            return assembler!
        }

        set {
            assembler = newValue
        }
    }

    static var assembler: Assembler?

    static func buildAssembler() -> Assembler {
        Assembler(allAssemblies)
    }

    static var allAssemblies: [Assembly] {
        [
            CameraAssembly(),
            RepositoriesAssembly(),
            ChatAssembly(),
            UtilsAssembly(),
        ]
    }
}
