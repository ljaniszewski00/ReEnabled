import SwiftUI

final class DistanceMeasurerViewModel: ObservableObject {
    @Inject var settingsProvider: SettingsProvider
    
    private let feedbackManager: FeedbackManager = .shared
    
    @Published var distance: Float?
    
    private var timer: Timer!
    private var canWarn: Bool = true
    
    init() {
        manageWarningPemission()
    }
    
    var obstacleIsNear: Bool {
        guard let distance = distance else {
            return false
        }
        
        let isNear: Bool = !distance.isNaN && distance >= 70 && distance < 100
        return isNear
    }
    
    var distanceString: String? {
        guard let distance = distance,
              !distance.isNaN else {
            return nil
        }
        
        let distanceMeasureUnit = settingsProvider.distanceMeasureUnit
        
        switch distanceMeasureUnit {
        case .centimeters:
            return String(format: "%.2f cm", distance)
        case .meters:
            let distanceFormatted: Float = distance * 0.01
            return String(format: "%.2f m", distanceFormatted)
        }
    }
    
    func warnAboutObstacle() {
        if canWarn {
            feedbackManager.generateHapticFeedback(.impact(.heavy))
            feedbackManager.generateSpeechFeedback(with: .camera(.mainRecognizer(.distanceWarning)))
            canWarn = false
        }
    }
    
    private func manageWarningPemission() {
        timer = Timer.scheduledTimer(timeInterval: 10.0,
                                     target: self, 
                                     selector: #selector(allowWarning),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc
    private func allowWarning() {
        canWarn = true
    }
}
