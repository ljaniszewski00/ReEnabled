import SwiftUI

final class DistanceMeasurerViewModel: ObservableObject {
    @Inject var settingsProvider: SettingsProvider
    
    private var feedbackManager: FeedbackManager = .shared
    
    @Published var canDisplayCamera: Bool = false
    @Published var distance: Float?
    
    var obstacleIsNear: Bool {
        guard let distance = distance else {
            return false
        }
        
        if distance.isNaN || distance < 70 {
            return true
        } else if !distance.isNaN && distance >= 70 && distance < 100 {
            return true
        } else if distance >= 100 && distance < 120 {
            return true
        } else {
            return false
        }
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
}
