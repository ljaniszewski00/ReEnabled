import Foundation

class ContinuousHapticFeedbackGenerator: ContinuousHapticFeedbackGenerating {
    private var generator: HapticFeedbackGenerating?
    private var pauseDuration: TimeInterval
    
    init(generator: HapticFeedbackGenerating,
         pauseDuration: TimeInterval = 0.2) {
        self.generator = generator
        self.pauseDuration = pauseDuration
    }
    
    @MainActor
    func generate(for sequence: ContinuousHapticFeedbackSequence) async {
        guard let generator = generator else {
            return
        }
        
        Task {
            for feedbackType in sequence.feedbackSequence {
                self.generator?.generate(feedbackType)
                try? await Task.sleep(for: .seconds(sequence.delay))
            }
        }
    }
    
    @MainActor
    func generate(for sequences: [ContinuousHapticFeedbackSequence], 
                  withDelayBetweenThem intersequenceDelay: Double) async {
        guard let generator = generator else {
            return
        }
        
        Task {
            for sequence in sequences {
                for (index, feedbackType) in sequence.feedbackSequence.enumerated() {
                    self.generator?.generate(feedbackType)
                    if index != (sequence.feedbackSequence.endIndex - 1) {
                        try? await Task.sleep(for: .seconds(sequence.delay))
                    }
                }
                try? await Task.sleep(for: .seconds(intersequenceDelay))
            }
        }
    }
}

protocol ContinuousHapticFeedbackGenerating {
    func generate(for sequence: ContinuousHapticFeedbackSequence) async
    func generate(for sequences: [ContinuousHapticFeedbackSequence],
                  withDelayBetweenThem intersequenceDelay: Double) async
}
