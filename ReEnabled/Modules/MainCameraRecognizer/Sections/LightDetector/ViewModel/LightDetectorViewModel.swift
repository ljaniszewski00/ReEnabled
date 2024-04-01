import SwiftUI

final class LightDetectorViewModel: ObservableObject {
    @Inject private var audioPlayerManager: AudioPlayerManaging
    
    @Published var luminosity: Double?
    @Published var canDisplayCamera: Bool = false
    
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
        
        soundIsPlaying = true
        audioPlayerManager.playWithIntensity(luminosity)
    }
    
    func stopSound() {
        soundIsPlaying = false
        audioPlayerManager.stopPlaying()
    }
}
