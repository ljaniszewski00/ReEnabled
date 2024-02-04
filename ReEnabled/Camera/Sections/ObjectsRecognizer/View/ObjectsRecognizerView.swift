import SwiftUI

struct ObjectsRecognizerView: View {
    @StateObject private var objectsRecognizerViewModel: ObjectsRecognizerViewModel = .shared
    
    var body: some View {
        ObjectsRecognizerViewControllerRepresentable()
    }
}

#Preview {
    ColorDetectorView()
}
