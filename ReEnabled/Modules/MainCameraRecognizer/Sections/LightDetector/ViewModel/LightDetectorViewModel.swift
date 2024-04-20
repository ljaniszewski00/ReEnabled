import SwiftUI

final class LightDetectorViewModel: ObservableObject {
    @Inject private var audioPlayerManager: AudioPlayerManaging
    
    @Published var luminosity: Double?
    
    private var feedbackManager: FeedbackManager = .shared
    
    var soundIsPlaying: Bool = false
    
    var detectedLuminosity: String? {
        guard let luminosity = luminosity else {
            return nil
        }
        
        return "\(String(format: "%.2f", luminosity))"
    }
    
    func playSound() {
        guard let luminosity = luminosity else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.soundIsPlaying = true
            self?.audioPlayerManager.playWithIntensity(luminosity)
        }
    }
    
    func stopSound() {
        soundIsPlaying = false
        audioPlayerManager.stopPlaying()
    }
}
