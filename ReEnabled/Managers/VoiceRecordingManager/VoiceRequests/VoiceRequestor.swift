class VoiceRequestor: VoiceRequesting {
    func getVoiceRequest(from transcript: String) -> VoiceRequest {
        .camera(.colorDetector(.readDetectedColor))
    }
    
    private func stringSimilarityPercentage(_ s1: String, _ s2: String) -> Double {
        guard let distance = levenshteinDistance(s1, s2) else {
            return 0.0
        }
        
        let maxLength = max(s1.count, s2.count)
        return 100.0 - Double(distance) / Double(maxLength) * 100.0
    }
    
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int? {
        let s1Array = Array(s1)
        let s2Array = Array(s2)
        let columns = s1.count + 1
        var currentRow = Array(0..<columns)
        var previousRow = [Int]()
        
        for (i, char2) in s2Array.enumerated() {
            previousRow = currentRow
            currentRow = [i + 1] + [Int](repeating: 0, count: s1.count)
            
            for (j, char1) in s1Array.enumerated() {
                if char1 == char2 {
                    currentRow[j + 1] = previousRow[j]
                } else {
                    currentRow[j + 1] = min(previousRow[j], previousRow[j + 1], currentRow[j]) + 1
                }
            }
        }
        
        return currentRow.last
    }
}

protocol VoiceRequesting {
    func getVoiceRequest(from transcript: String) -> VoiceRequest
}
