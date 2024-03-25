import CoreML
import Foundation
import UIKit
import Vision

class PedestrianCrossingModel {
    let class_labels: [String] = ["red", "green", "yellow", "none"]
    let class_colors: [UIColor] = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.lightGray]
    
    var translate_matrix = simd_double3x3(
        [
            simd_double3(x: -1.17079727*pow(10,-1),
                         y: -9.02276490*pow(10, -16),
                         z: -2.75975270*pow(10, -19)),
            simd_double3(x: -1.56391162,
                         y: -2.59783431,
                         z: -7.75749810*pow(10,-4)),
            simd_double3(x: 2.25203273*pow(10, 3),
                         y: 3.71606050*pow(10, 3),
                         z: 1.0)
        ]
    )

    var prob_store: [[Double]] = [
        [0,0,0,0],
        [0,0,0,0],
        [0,0,0,0],
        [0,0,0,0],
        [0,0,0,0]
    ]
    
    var direcStore: [[Double]] = [[],[],[],[],[]]
    var direcStoreAvg: [Double] = [0,0,0,0]
    var probStoreAvg: [Double] = [0,0,0,0]
    var counter = 0
    var start = CFAbsoluteTimeGetCurrent()
    
    var label: String = ""
    var points: [Double] = []
    var color: UIColor = .tintColor
    var color2: UIColor = .tintColor
    var label2: String = ""
    var points2: [Double] = []
    var transposed: [Double] = []
    
    var pedestrianCrossingPrediction: PedestrianCrossingPrediction?
    
    func performCalculationsOn(output: [VNCoreMLFeatureValueObservation]) {
        let direction = output[1].featureValue.multiArrayValue
        let classes = output[0].featureValue.multiArrayValue
        let classesSimplified: [Double] = [
            classes![0].doubleValue,
            classes![1].doubleValue,
            classes![2].doubleValue + classes![3].doubleValue,
            classes![4].doubleValue
        ]
        let coords = [
            direction![0].doubleValue,
            direction![1].doubleValue,
            direction![2].doubleValue,
            direction![3].doubleValue
        ]
        
        let point1_ = self.translate_matrix*simd_double3(
            x:self.direcStoreAvg[0]*4032,
            y:self.direcStoreAvg[1]*3024,
            z:1
        )
        
        let point2_ = self.translate_matrix*simd_double3(
            x:self.direcStoreAvg[2]*4032,
            y:self.direcStoreAvg[3]*3024,
            z:1
        )
        
        var point1__: [Double] = [
            point1_[0]/point1_[2],
            point1_[1]/point1_[2]
        ]
        
        let point2__: [Double] = [
            point2_[0]/point2_[2],
            point2_[1]/point2_[2]
        ]
        
        let slope = (point2__[1]-point1__[1])/(point1__[0]-point2__[0])
        
        var angle = atan(slope)*180/Double.pi
        point1__[1] = 3024-point1__[1]
        
        let start = (0-point1__[1])/slope + point1__[0]
        let transposed_coords = [
            point1__[0]/4032,
            (3024-point1__[1])/3024,
            point2__[0]/4032,
            point2__[1]/3024
        ]

        self.prob_store[self.counter%5] = classesSimplified
        self.direcStore[self.counter%5] = coords

        var personPositionActionType: PersonPositionActionType = .goodPosition
        var deviceOrientationActionType: DeviceOrientationActionType = .goodOrientation
        
        if(start > 2166){
            personPositionActionType = .moveRight
        } else if(start < 1866){
            personPositionActionType = .moveLeft
        }
        
        if(angle < 0.0){
            angle = 180 + angle
        }
        
        if(90.0-angle > 10.0){
            deviceOrientationActionType = .turnRight
        } else if(90.0-angle < -10.0){
            deviceOrientationActionType = .turnLeft
        }
        
        var index = 0
        for i in 1...3{
            if classesSimplified[i] > classesSimplified[index]{
                index = i
            }
        }
        
        let outputClass = self.class_labels[index]
        let color = self.class_colors[index]
        
        if self.counter%5==4{
            self.probStoreAvg = [0,0,0,0]
            self.direcStoreAvg = [0,0,0,0]
            
            for i in 0...4{
                for j in 0...3{
                    self.probStoreAvg[j] += self.prob_store[i][j]
                }
            }
            
            for i in 0...3{
                self.direcStoreAvg[i] += (self.direcStore[0][i]+self.direcStore[1][i]+self.direcStore[2][i]+self.direcStore[3][i]+self.direcStore[4][i])/5
            }
            
            for k in 0...3{
                self.probStoreAvg[k] = self.probStoreAvg[k]/5
            }
        }
        
        var indexAvg = 0
        for i in 1...3{
            if self.probStoreAvg[i] > self.probStoreAvg[indexAvg]{
                indexAvg = i
            }
        }
        
        var outputClassAvg = self.class_labels[indexAvg]
        var colorAvg = self.class_colors[indexAvg]
        
        if self.probStoreAvg[indexAvg] < 0.8{
            outputClassAvg = "No Decision"
            colorAvg = UIColor.darkGray
        }
        
        self.counter += 1
        
        self.label = outputClass
        self.points = coords
        self.color = color
        self.color2 = colorAvg
        self.label2 = outputClassAvg
        self.points2 = self.direcStoreAvg
        self.transposed = transposed_coords
        
        if let lightColor = PedestrianCrossingLightType(rawValue: outputClass) {
            self.pedestrianCrossingPrediction = PedestrianCrossingPrediction(
                lightColor: lightColor,
                personMovementInstruction: personPositionActionType,
                deviceMovementInstruction: deviceOrientationActionType)
        }
    }
}
