//
//  Created by Patrick Valenta on 04.10.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import Foundation
import UIKit

class RoadLightsPhaseManager {
    
    struct Detection: Comparable {
        var rect: CGRect
        var confirmed: Int
        var detectedInCurrentFrame: Bool
        var phase: LightPhase
        
        mutating func confirm() {
            self.confirmed += 1
            self.detectedInCurrentFrame = true
        }
        
        static func ==(lhs: Detection, rhs: Detection) -> Bool {
            return (lhs.rect.width * lhs.rect.height) < (rhs.rect.width * rhs.rect.height)
        }
        
        static func <(lhs: Detection, rhs: Detection) -> Bool {
            return (lhs.rect.width * lhs.rect.height) < (rhs.rect.width * rhs.rect.height)
        }
    }
    
    public enum LightPhase {
        case red
        case green
        case none
        
        func description() -> String {
            switch self {
            case .red: return "Red"
            case .green: return "Green"
            case .none: return "None"
            }
        }
    }
    
    // Determines how often a detection needs to be validated
    // until considered for light phase determination
    var confidenceThreshold: Int
    
    // Determines the minimum Intersect over union of a detection
    // to be validated as detected over multiple frames
    var minIOU: Float
    var maxDetections: Int
    
    var detections: [Detection] = [Detection]()
    
    // Keeping the state of detections for a certain amount of frames.
    // Allows for smoother transition between changes of state
    var maxFramesWithNoDetection: Int = 5
    private var framesWithNoDetection: Int = 0
    
    var currentPhase: LightPhase = RoadLightsPhaseManager.LightPhase.none
    
    init(confidenceThreshold: Int, maxDetections: Int, minIOU: Float) {
        self.confidenceThreshold = confidenceThreshold
        self.minIOU = minIOU
        self.maxDetections = maxDetections
    }
    
    func add(predictions: [RoadLightsModel.RoadLightsPrediction]) {
        var toBeAdded = [Detection]()
        
        for i in 0..<detections.count {
            detections[i].detectedInCurrentFrame = false
        }
        
        for prediction in predictions {
            // Check if prediction exists in detections
            let existingDetection = self.predictionExistsInDetections(prediction: prediction)
            
            if existingDetection == nil {
                let newDetection = Detection(rect: prediction.rect,
                                             confirmed: 0,
                                             detectedInCurrentFrame: true,
                                             phase: self.classIndexToPhase(prediction.classIndex))
                // -> No. detections.length < maxDetections?
                if detections.count < self.maxDetections {
                    // -> Yes. add it to detections
                    detections.append(newDetection)
                } else {
                    // -> No. add it later
                    toBeAdded.append(newDetection)
                }
            }
        }
        
        // Keeping the current state of detections if no new detections came in until
        // framesWithNoDetection exceeds maxFramesWithNoDetection
        if predictions.count == 0 && framesWithNoDetection <= maxFramesWithNoDetection  {
            // Increment backdoor count
            framesWithNoDetection += 1
        } else {
            // Remove all detections that have not been detected in this frame
            // or set detections to only have detections that have been detected in the current frame
            detections = detections.filter { $0.detectedInCurrentFrame }

            framesWithNoDetection = 0
        }
    }
    
    func determine() -> LightPhase {
        let qualifiedDetections = detections.filter { $0.confirmed >= self.confidenceThreshold }
        
        if qualifiedDetections.count == 0 {
            self.currentPhase = LightPhase.none
            return self.currentPhase
        }
        
        // Get detection with the largest area, which is most likely the closest on the frame
        if let max = detections.max() {
            self.currentPhase = max.phase
        }
        
        return self.currentPhase
    }
    
    private func predictionExistsInDetections(prediction: RoadLightsModel.RoadLightsPrediction) -> Detection? {
        for i in 0..<detections.count {
            let det = detections[i]
            let debugIOU = IOU(a: det.rect, b: prediction.rect)

            if debugIOU >= self.minIOU {
                detections[i].confirm()
                return det
            }
        }
        
        return nil
    }
    
    private func classIndexToPhase(_ index: Int) -> LightPhase {
        return index == 0 ? .red : .green
    }
}
