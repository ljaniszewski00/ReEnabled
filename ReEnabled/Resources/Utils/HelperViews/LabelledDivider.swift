import SwiftUI

struct LabelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 30, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack(spacing: horizontalPadding) {
            line
            Text(label)
                .font(.callout)
                .foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack {
            Divider().background(color)
        }
    }
}
