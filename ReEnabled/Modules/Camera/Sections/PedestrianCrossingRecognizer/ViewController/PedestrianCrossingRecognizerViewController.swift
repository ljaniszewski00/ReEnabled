import AVFoundation
import SwiftUI
import UIKit
import Vision
import CoreML

class PedestrianCrossingRecognizerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Inject private var captureSessionManager: CaptureSessionManaging
    private var pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel?
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil
    
    var translate_matrix = simd_double3x3([simd_double3(x: -1.17079727*pow(10,-1), 
                                                        y: -9.02276490*pow(10, -16),
                                                        z: -2.75975270*pow(10, -19)),
                                           simd_double3(x: -1.56391162,
                                                        y: -2.59783431,
                                                        z: -7.75749810*pow(10,-4)),
                                           simd_double3(x: 2.25203273*pow(10, 3),
                                                        y: 3.71606050*pow(10, 3),
                                                        z: 1.0)])

    var prob_store: [[Double]] = [
        [0,0,0,0],
        [0,0,0,0],
        [0,0,0,0],
        [0,0,0,0],
        [0,0,0,0]
    ]

    var class_labels: [String] = ["red", "green", "yellow", "none"]
    var class_colors: [UIColor] = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.lightGray]
    var direc_store: [[Double]] = [[],[],[],[],[]]
    var direc_store_avg: [Double] = [0,0,0,0]
    var prob_store_avg: [Double] = [0,0,0,0]
    var counter = 0
    var start = CFAbsoluteTimeGetCurrent()
    var last_beep = 0.0
    var last_start = 0.0
    var last_angle = 0.0
    var last_instruction = 0.0
    var previous_decision = ""
    var label_constant = 0
    var pos_good = false
    var angle_good = false
    var informed_pos = false
    var informed_angle = false
    
    let label: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(24)
        label.isHighlighted = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Label", 
                                                  attributes: [
                                                    NSAttributedString.Key.foregroundColor: UIColor.white,
                                                    NSAttributedString.Key.backgroundColor: UIColor.yellow
                                                  ])
        return label
    }()
    
    let five_frame_average: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(24)
        label.isHighlighted = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Label", attributes: [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.backgroundColor: UIColor.yellow])
        return label
    }()
    
    let angle_decision: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(24)
        label.isHighlighted = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "good orientation"
        return label
    }()
    
    let start_decision: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(24)
        label.isHighlighted = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Good Start"
        return label
    }()
    
    
    private var detectionOverlay: CALayer! = nil
    
    private var requests = [VNRequest]()
    
    init(pedestrianCrossingRecognizerViewModel: PedestrianCrossingRecognizerViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.pedestrianCrossingRecognizerViewModel = pedestrianCrossingRecognizerViewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.pedestrianCrossingRecognizerViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionManager.setUp(with: self,
                                    for: .pedestrianCrossingRecognizer,
                                    cameraPosition: .back,
                                    desiredFrameRate: 21) {
            self.setupSessionPreviewLayer()
            self.setupLayers()
            self.updateLayerGeometry()
            self.setupDetector()
            
            DispatchQueue.main.async {
                self.addSubviews()
                self.setupLabel()
                self.pedestrianCrossingRecognizerViewModel?.canDisplayCamera = true
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRect = UIScreen.main.bounds
        self.previewLayer.frame = CGRect(x: 0,
                                         y: 0,
                                         width: screenRect.size.width,
                                         height: screenRect.size.height)

        switch UIDevice.current.orientation {
        case UIDeviceOrientation.portraitUpsideDown:
            self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case UIDeviceOrientation.landscapeLeft:
            self.previewLayer.connection?.videoOrientation = .landscapeRight
        case UIDeviceOrientation.landscapeRight:
            self.previewLayer.connection?.videoOrientation = .landscapeLeft
        case UIDeviceOrientation.portrait:
            self.previewLayer.connection?.videoOrientation = .portrait
        default:
            break
        }
    }
    
    private func addSubviews() {
        view.addSubview(label)
        view.addSubview(five_frame_average)
        view.addSubview(angle_decision)
        view.addSubview(start_decision)
    }
    
    private func setupSessionPreviewLayer() {
        screenRect = UIScreen.main.bounds
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSessionManager.captureSession)
        previewLayer.frame = CGRect(x: 0,
                                    y: 0,
                                    width: screenRect.size.width,
                                    height: screenRect.size.height)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.view.layer.addSublayer(self.previewLayer)
        }
    }
}

extension PedestrianCrossingRecognizerViewController {
    private func setupDetector() {
        let pedestrianCrossingRecognizerModelURL = Bundle.main.url(
            forResource: MLModelFile.pedestrianCrossingRecognizer.fileName,
            withExtension: "mlmodelc"
        )
    
        do {
            if let pedestrianCrossingRecognizerModelURL = pedestrianCrossingRecognizerModelURL {
                let visionPedestrianCrossingModel = try VNCoreMLModel(for: MLModel(contentsOf: pedestrianCrossingRecognizerModelURL))
                let request = VNCoreMLRequest(model: visionPedestrianCrossingModel, completionHandler: pedestrianCrossingDetectionDidComplete)
                self.requests = [request]
            }
        } catch {
            return
        }
    }
    
    private func pedestrianCrossingDetectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            
            guard let output = results as? [VNCoreMLFeatureValueObservation] else {
                return
            }
            
            print("THERE ARE RESULTS AS VNCoreMLFeatureValueObservation")
            for singleOutput in output {
                print(singleOutput)
            }
            print()
            
            let direction = output[1].featureValue.multiArrayValue
            let classes = output[0].featureValue.multiArrayValue
            let classes_simplified: [Double] = [classes![0].doubleValue, classes![1].doubleValue, classes![2].doubleValue + classes![3].doubleValue, classes![4].doubleValue]
            let coords = [direction![0].doubleValue, direction![1].doubleValue, direction![2].doubleValue, direction![3].doubleValue]
            
            let point1_ = self.translate_matrix*simd_double3(x:self.direc_store_avg[0]*4032,y:self.direc_store_avg[1]*3024,z:1)
            let point2_ = self.translate_matrix*simd_double3(x:self.direc_store_avg[2]*4032,y:self.direc_store_avg[3]*3024,z:1)
            var point1__: [Double] = [point1_[0]/point1_[2], point1_[1]/point1_[2]]
            let point2__: [Double] = [point2_[0]/point2_[2], point2_[1]/point2_[2]]
            let slope = (point2__[1]-point1__[1])/(point1__[0]-point2__[0])
            var angle = atan(slope)*180/Double.pi
            point1__[1] = 3024-point1__[1]
            let start = (0-point1__[1])/slope + point1__[0]
            let transposed_coords = [point1__[0]/4032,(3024-point1__[1])/3024,point2__[0]/4032, point2__[1]/3024]
 
            self.prob_store[self.counter%5] = classes_simplified
            self.direc_store[self.counter%5] = coords

            var angle_text = "good orientation"
            var start_text = "good startpoint"
            if(start > 2166){
                start_text = "move right"
            }
            else if(start < 1866){
                start_text = "move left"
            }
            if(angle < 0.0){
                angle = 180 + angle
            }
            if(90.0-angle > 10.0){
                angle_text = "turn right"
            }
            else if(90.0-angle < -10.0){
                angle_text = "turn left"
            }
            
            var index = 0
            for i in 1...3{
                if classes_simplified[i] > classes_simplified[index]{
                    index = i
                }
            }
            
            let output_class = self.class_labels[index]
            let color = self.class_colors[index]
            
            print("Here is predicted class")
            print(output_class)
            print()
            
            if self.counter%5==4{
                self.prob_store_avg = [0,0,0,0]
                self.direc_store_avg = [0,0,0,0]
                for i in 0...4{
                    for j in 0...3{
                        self.prob_store_avg[j] += self.prob_store[i][j]
                    }
                }
                for i in 0...3{
                    self.direc_store_avg[i] += (self.direc_store[0][i]+self.direc_store[1][i]+self.direc_store[2][i]+self.direc_store[3][i]+self.direc_store[4][i])/5
                }
                for k in 0...3{
                    self.prob_store_avg[k] = self.prob_store_avg[k]/5
                }
            }
            
            var index_avg = 0
            for i in 1...3{
                if self.prob_store_avg[i] > self.prob_store_avg[index_avg]{
                    index_avg = i
                }
            }
            var output_class_avg = self.class_labels[index_avg]
            var color_avg = self.class_colors[index_avg]
            if self.prob_store_avg[index_avg] < 0.8{
                output_class_avg = "no decision"
                color_avg = UIColor.darkGray
            }
            
            self.counter += 1
            
            DispatchQueue.main.async(execute: {
                self.drawVisionRequestResults(label: output_class, 
                                              points: coords,
                                              color: color,
                                              color2: color_avg,
                                              label2: output_class_avg,
                                              points2: self.direc_store_avg,
                                              angle: angle_text,
                                              start: start_text,
                                              transposed: transposed_coords)
            })
        }
    }
    
    private func drawVisionRequestResults(label: String, 
                                          points: [Double],
                                          color: UIColor,
                                          color2: UIColor,
                                          label2: String,
                                          points2: [Double],
                                          angle: String,
                                          start: String,
                                          transposed: [Double]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil
        
        let shapeLayer = self.createLine(points: points, color: UIColor.blue)
        self.angle_decision.text = angle
        self.start_decision.text = start
        self.label.attributedText = NSAttributedString(string: label, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.backgroundColor: color])
        self.five_frame_average.attributedText = NSAttributedString(string: label2, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.backgroundColor: color2])
        detectionOverlay.addSublayer(shapeLayer)
        let shapeLayer2 = self.createLine(points: points2, color: UIColor.red)
        detectionOverlay.addSublayer(shapeLayer2)
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    func setupLayers() {
        detectionOverlay = CALayer()
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0,
                                        y: 0.0,
                                        width: captureSessionManager.bufferSize.width,
                                        height: captureSessionManager.bufferSize.height)
        detectionOverlay.position = CGPoint(x: self.view.layer.bounds.midX,
                                            y: self.view.layer.bounds.midY)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.view.layer.addSublayer(self.detectionOverlay)
        }
    }
    
    func updateLayerGeometry() {
        let bounds = self.view.layer.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / captureSessionManager.bufferSize.height
        let yScale: CGFloat = bounds.size.height / captureSessionManager.bufferSize.width
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)

        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        CATransaction.commit()
    }
    
    private func createLine(points: [Double], color: UIColor) -> CALayer {
        let shapeLayer = CALayer()
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        shapeLayer.name = "Direction Vector"
        linePath.move(to: CGPoint(x:points[2]*960+160, y:720.0-points[3]*720))
        linePath.addLine(to: CGPoint(x:points[0]*960+160,y:720.0-points[1]*720))
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.lineWidth = 5.0
        line.strokeColor = color.cgColor
        shapeLayer.addSublayer(line)
        return shapeLayer
    }

    private func setupLabel() {
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -150).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -210).isActive = true
        label.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
        five_frame_average.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:-45).isActive = true
        five_frame_average.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -210).isActive = true
        five_frame_average.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
        angle_decision.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
        angle_decision.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -210).isActive = true
        angle_decision.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
        start_decision.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
        start_decision.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -210).isActive = true
        start_decision.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.captureSessionManager.manageFlashlight(for: sampleBuffer, force: nil)
        }

        guard let cvPixelBuffer = sampleBuffer.convertToPixelBuffer() else {
            return
        }
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        let handler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer,
                                            orientation: exifOrientation)

        do {
            try handler.perform(self.requests)
        } catch {
            return
        }
    }
}
