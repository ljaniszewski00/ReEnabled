import SwiftUI

struct FacialRecognizerView: View {
    @StateObject private var facialRecognizerViewModel: FacialRecognizerViewModel = FacialRecognizerViewModel()
    
    var body: some View {
        ZStack {
            FacialRecognizerViewControllerRepresentable(facialRecognizerViewModel: facialRecognizerViewModel)
            
            VStack {
                Spacer()
                
                Group {
                    Text("Gender: \(facialRecognizerViewModel.recognizedGender)")
                    Text("Age: \(facialRecognizerViewModel.recognizedAge)")
                    Text("Emotion: \(facialRecognizerViewModel.recognizedEmotion)")
                }
                .foregroundColor(.white)
                .font(.headline)
            }
            .padding(.bottom, Views.Constants.recognitionsBottomPadding)
        }
        .onLongPressGesture {
            facialRecognizerViewModel.enableRecognition()
        }
    }
}

#Preview {
    FacialRecognizerView()
}

private extension Views {
    struct Constants {
        static let recognitionsBottomPadding: CGFloat = 100
    }
}
