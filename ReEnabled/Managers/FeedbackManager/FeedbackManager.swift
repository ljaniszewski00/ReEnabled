import AVFoundation
import Combine
import Foundation
import UIKit

class FeedbackManager: ObservableObject {
    private var hapticTimer: AnyCancellable?
    private var continuousHapticTimer: AnyCancellable?
    private var speechTimer: AnyCancellable?
    
    private var speechSynthesizer: AVSpeechSynthesizer?
    private var speechVoice: AVSpeechSynthesisVoice?
    
    @Published var shouldStartHaptic: Bool = false
    @Published var shouldStartContinuousHaptic: Bool = false
    @Published var shouldStartSpeech: Bool = false
    
    private var cancelBag = Set<AnyCancellable>()
    
    private init() {
        self.setupHapticDemandObservation()
        self.setupContinuousHapticDemandObservation()
        self.setupSpeechDemandObservation()
        
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.speechVoice = AVSpeechSynthesisVoice(language: SupportedLanguage.polish.languageCode)
    }
    
    static let shared: FeedbackManager = {
        FeedbackManager()
    }()
    
    func changeVoiceLanguage(to language: SupportedLanguage) {
        self.speechVoice = AVSpeechSynthesisVoice(language: language.languageCode)
    }
    
    func executeHapticFeedback() {
        
    }
    
    func executeNextTypeOfContinuousHapticFeedback() {
        guard continuousHapticSequence.indices.contains(currentContinuousHapticSequenceIndex) else {
            return
        }
        
        let hapticType = continuousHapticSequence[currentContinuousHapticSequenceIndex]
        generateHapticFeedback(of: hapticType)
        
        currentContinuousHapticSequenceIndex = (currentContinuousHapticSequenceIndex + 1) % continuousHapticSequence.count
    }
    
    private func generateHapticFeedback(of type: HapticFeedbackType) {
        continuousHapticQueue.addOperation(SignalOperation(operation: {
            switch type {
            case .notificationError:
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(.error)
            case .notificationSuccess:
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(.success)
            case .notificationWarning:
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(.warning)
            case .impactLight:
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.prepare()
                generator.impactOccurred()
            case .impactMedium:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
            case .impactHeavy:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()
            }
        }))
    }
    
    class SignalOperation: Operation {
        private let operation: () -> ()
        
        init(operation: @escaping () -> Void) {
            self.operation = operation
        }
        
        override func main() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.operation()
            }
            
            Thread.sleep(forTimeInterval: 0.8)
        }
    }
    
    func executeSpeechFeedback(text: String) {
        if let isSpeaking = self.speechSynthesizer?.isSpeaking {
            if isSpeaking {
                return
            }
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = self.speechVoice
        self.speechSynthesizer?.speak(utterance)
    }
    
    // MARK: - Haptic Feedback
    
    private func setupHapticDemandObservation() {
        $shouldStartHaptic
            .sink { [weak self] shouldStart in
                guard let self = self else {
                    return
                }
                
                shouldStart ? self.startHapticTimer() : self.stopHapticTimer()
            }
            .store(in: &cancelBag)
    }
    
    private func startHapticTimer() {
        stopHapticTimer()
        
        hapticTimer = Timer
            .publish(every: 0.6, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                
            }
    }
    
    private func stopHapticTimer() {
        hapticTimer?.cancel()
        hapticTimer = nil
    }
    
    // MARK: - Continuous Haptic Feedback
    
    private lazy var continuousHapticQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private var continuousHapticSequence: [HapticFeedbackType] = [
        .impactLight,
        .impactMedium,
        .impactHeavy
    ]
    
    private var currentContinuousHapticSequenceIndex = 0
    private let timeBetweenHapticOcurrences: Double = 0.8
    
    private func setupContinuousHapticDemandObservation() {
        $shouldStartContinuousHaptic
            .sink { [weak self] shouldStart in
                guard let self = self else {
                    return
                }
                
                print()
                print("HERE")
                print(shouldStart)
                print()
                
                shouldStart ? self.startContinuousHapticTimer() : self.stopContinuousHapticTimer()
            }
            .store(in: &cancelBag)
    }
    
    private func startContinuousHapticTimer() {
        stopContinuousHapticTimer()
        
        continuousHapticTimer = Timer
            .publish(every: 0.8, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                self.executeNextTypeOfContinuousHapticFeedback()
            }
    }
    
    private func stopContinuousHapticTimer() {
        continuousHapticTimer?.cancel()
        continuousHapticTimer = nil
        currentContinuousHapticSequenceIndex = 0
    }
    
    // MARK: - Speech Feedback
    
    private func setupSpeechDemandObservation() {
        $shouldStartSpeech
            .sink { [weak self] shouldStart in
                guard let self = self else {
                    return
                }
                
                shouldStart ? self.startSpeechTimer() : self.stopSpeechTimer()
            }
            .store(in: &cancelBag)
    }
    
    private func startSpeechTimer() {
        stopSpeechTimer()
        
        speechTimer = Timer
            .publish(every: 0.6, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                
            }
    }
    
    private func stopSpeechTimer() {
        speechTimer?.cancel()
        speechTimer = nil
    }
}

extension FeedbackManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
