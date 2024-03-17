import AVFoundation

struct SessionPreset {
    let preset: AVCaptureSession.Preset
    let formatWidth: Int32
    let formatHeight: Int32
}

extension SessionPreset {
    static let hd1280x720 = SessionPreset(preset: .hd1280x720,
                                          formatWidth: 1280,
                                          formatHeight: 720)
}
