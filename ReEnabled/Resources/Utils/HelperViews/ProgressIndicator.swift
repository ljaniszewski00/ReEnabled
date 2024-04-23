import SwiftUI

struct ProgressIndicator: View {
    var stepsNumber: Int
    var activeStep: Int
    
    var body: some View {
        HStack(spacing: Views.Constants.hStackSpacing) {
            Spacer()
            
            ForEach(Views.Constants.firstStepNumber...stepsNumber, id: \.self) { stepNumber in
                ZStack {
                    Circle()
                        .foregroundColor(.accentColor)
                        .if(stepNumber != activeStep) {
                            $0
                                .opacity(Views.Constants.notActiveStepElementOpacity)
                        }
                    if activeStep > stepNumber {
                        Image(systemName: Views.Constants.completedStepCircleImageName)
                            .foregroundColor(.accentColor)
                    } else {
                        Text("\(stepNumber)")
                            .bold()
                    }
                }
                if stepNumber != stepsNumber {
                    Rectangle()
                        .foregroundColor(.accentColor)
                        .frame(height: Views.Constants.stepRectangleFrameHeight)
                        .if(stepNumber != activeStep) {
                            $0
                                .opacity(Views.Constants.notActiveStepElementOpacity)
                        }
                }
            }
            
            Spacer()
        }
    }
}

struct ProgressIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIndicator(stepsNumber: 4, activeStep: 3)
    }
}

private extension Views {
    struct Constants {
        static let hStackSpacing: CGFloat = 0
        static let firstStepNumber: Int = 1
        static let notActiveStepElementOpacity: CGFloat = 0.5
        static let completedStepCircleImageName: String = "checkmark"
        static let stepRectangleFrameHeight: CGFloat = 5
    }
}
