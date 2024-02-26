import SwiftUI

struct ObjectsRecognizerView: View {
    @StateObject private var objectsRecognizerViewModel: ObjectsRecognizerViewModel = ObjectsRecognizerViewModel()
    
    var body: some View {
        ObjectsRecognizerViewControllerRepresentable(objectsRecognizerViewModel: objectsRecognizerViewModel)
    }
}

#Preview {
    ColorDetectorView()
}
