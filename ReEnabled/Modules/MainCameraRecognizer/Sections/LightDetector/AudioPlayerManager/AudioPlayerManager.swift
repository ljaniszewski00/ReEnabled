import AVFoundation

final class AudioPlayerManager: AudioPlayerManaging {
    private var audioPlayer: AVAudioPlayer?
    private let audioResource: String = AudioResource.laserBeam.rawValue
    
    init() {
        prepareToPlay()
    }
    
    func prepareToPlay() {
        guard let soundURL = Bundle.main.url(forResource: audioResource, withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback,
                options: AVAudioSession.CategoryOptions.duckOthers
            )
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            return
        }
    }
    
    func playWithIntensity(_ intensity: Double) {
        audioPlayer?.volume = Float(intensity)
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
    }
}

protocol AudioPlayerManaging {
    func playWithIntensity(_ intensity: Double)
    func stopPlaying()
}
