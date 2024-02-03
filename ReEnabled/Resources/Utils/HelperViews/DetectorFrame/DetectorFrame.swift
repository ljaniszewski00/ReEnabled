import SwiftUI

struct DetectorFrame: View {
    var outerCircleFrameSize: CGFloat = Views.Constants.outerCircleFrameSize
    var innerCircleFrameSize: CGFloat = Views.Constants.innerCircleFrameSize
    var xPosition: CGFloat = UIScreen.main.bounds.width / Views.Constants.positionDivider
    var yPosition: CGFloat = UIScreen.main.bounds.height / Views.Constants.positionDivider
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.red, 
                        lineWidth: Views.Constants.outerCircleLineWidth)
                .opacity(Views.Constants.outerCircleOpacity)
                .frame(width: outerCircleFrameSize,
                       height: outerCircleFrameSize)
            
            Circle()
                .frame(width: innerCircleFrameSize,
                       height: innerCircleFrameSize)
                .foregroundColor(
                    Color(white: Views.Constants.innerCircleColorWhiteValue, 
                          opacity: Views.Constants.innerCircleColorOpacityValue)
                )
        }
        .position(x: xPosition,
                  y: yPosition)
    }
}

#Preview {
    DetectorFrame()
}

private extension Views {
    struct Constants {
        static let outerCircleLineWidth: CGFloat = 5
        static let outerCircleOpacity: CGFloat = 0.5
        static let outerCircleFrameSize: CGFloat = 40
        static let innerCircleFrameSize: CGFloat = 8
        static let innerCircleColorWhiteValue: CGFloat = 0.7
        static let innerCircleColorOpacityValue: CGFloat = 0.5
        static let positionDivider: CGFloat = 2
    }
}
