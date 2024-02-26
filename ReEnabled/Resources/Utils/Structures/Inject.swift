import Swinject

@propertyWrapper
struct Inject<Component> {

    let wrappedValue: Component

    init() {
        self.wrappedValue = Assembler.default.resolver.resolve(Component.self)!
    }
}
