import UIKit

final class HapticFeedbackGenerator: HapticFeedbackGenerating {
    private var generator: UINotificationFeedbackGenerator {
        return UINotificationFeedbackGenerator()
    }
    
    private var impactGenerator: (light: UIImpactFeedbackGenerator,
                                  medium: UIImpactFeedbackGenerator,
                                  heavy: UIImpactFeedbackGenerator) {
        return (light: UIImpactFeedbackGenerator(style: .light), 
                medium: UIImpactFeedbackGenerator(style: .medium),
                heavy: UIImpactFeedbackGenerator(style: .heavy))
    }

    func prepare() {
        generator.prepare()
        impactGenerator.heavy.prepare()
        impactGenerator.medium.prepare()
        impactGenerator.light.prepare()
    }
    
    func generate(_ feedback: HapticFeedbackType) {
        prepare()
        switch feedback {
        case .notification(let hapticNotificationFeedbackType):
            switch hapticNotificationFeedbackType {
            case .success:
                generator.notificationOccurred(.success)
            case .error:
                generator.notificationOccurred(.error)
            case .warning:
                generator.notificationOccurred(.success)
            @unknown default:
                return
            }
        case .impact(let hapticImpactFeedbackType):
            switch hapticImpactFeedbackType {
            case .light:
                impactGenerator.light.impactOccurred()
            case .medium:
                impactGenerator.medium.impactOccurred()
            case .heavy:
                impactGenerator.heavy.impactOccurred()
            }
        }
    }
}

protocol HapticFeedbackGenerating {
    func prepare()
    func generate(_ feedback: HapticFeedbackType)
}
