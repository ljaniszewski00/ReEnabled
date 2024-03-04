import AVFoundation
import Foundation
import SwiftUI

final class FlashlightManager: FlashlightManaging {
    func manageFlashlight(for sampleBuffer: CMSampleBuffer?,
                          and captureDevice: AVCaptureDevice?,
                          force torchMode: AVCaptureDevice.TorchMode? = nil) {
        if let torchMode = torchMode {
            setTorchMode(torchMode, for: captureDevice)
            return
        }
        
        guard let sampleBuffer = sampleBuffer,
              let luminosity = CaptureSessionManager.getLuminosityValueFromCamera(with: sampleBuffer) else {
            return
        }
        
        if luminosity < 1.6 {
            setTorchMode(.on, for: captureDevice)
        } else {
            setTorchMode(.off, for: captureDevice)
        }
    }
    
    private func setTorchMode(_ torchMode: AVCaptureDevice.TorchMode, for captureDevice: AVCaptureDevice?) {
        guard captureDevice != nil else {
            return
        }
        
        do {
            try captureDevice!.lockForConfiguration()
            
            if captureDevice!.hasTorch {
                captureDevice!.torchMode = torchMode
            }
            
            captureDevice!.unlockForConfiguration()
        } catch {
            return
        }
    }
}

protocol FlashlightManaging {
    func manageFlashlight(for sampleBuffer: CMSampleBuffer?,
                          and captureDevice: AVCaptureDevice?,
                          force torchMode: AVCaptureDevice.TorchMode?)
}
