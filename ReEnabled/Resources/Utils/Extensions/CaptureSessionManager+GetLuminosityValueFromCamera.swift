import AVFoundation

extension CaptureSessionManager {
    static func getLuminosityValueFromCamera(with sampleBuffer: CMSampleBuffer) -> Double? {
        let rawMetadata = CMCopyDictionaryOfAttachments(allocator: nil,
                                                        target: sampleBuffer,
                                                        attachmentMode: CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))
        let metadata = CFDictionaryCreateMutableCopy(nil, 0, rawMetadata) as NSMutableDictionary
        
        guard let exifData = metadata.value(forKey: "{Exif}") as? NSMutableDictionary,
              let fNumber: Double = exifData["FNumber"] as? Double,
              let exposureTime: Double = exifData["ExposureTime"] as? Double,
              let ISOSpeedRatingsArray = exifData["ISOSpeedRatings"] as? NSArray,
              let ISOSpeedRatings: Double = ISOSpeedRatingsArray[0] as? Double else {
            return nil
        }
        
        let calibrationConstant: Double = 50
        
        let luminosity: Double = (calibrationConstant * fNumber * fNumber) / (exposureTime * ISOSpeedRatings)
        
        return luminosity
    }
}
