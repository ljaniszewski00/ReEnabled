import SwiftUI

struct CustomNavigationBar<LeadingItem,
                            SecondLeadingItem,
                            TrailingItem,
                            SecondTrailingItem>: View where LeadingItem: View,
                                                                SecondLeadingItem: View,
                                                                TrailingItem: View,
                                                                SecondTrailingItem: View {
    private let title: String
    private let leadingItem: () -> LeadingItem
    private let secondLeadingItem: () -> SecondLeadingItem
    private let trailingItem: () -> TrailingItem
    private let secondTrailingItem: () -> SecondTrailingItem
    
    init(title: String,
         @ViewBuilder leadingItem: @escaping () -> LeadingItem = { Text("") },
         @ViewBuilder secondLeadingItem: @escaping () -> SecondLeadingItem = { Text("") },
         @ViewBuilder trailingItem: @escaping () -> TrailingItem = { Text("") },
         @ViewBuilder secondTrailingItem: @escaping () -> SecondTrailingItem = { Text("") }) {
        self.title = title
        self.leadingItem = leadingItem
        self.secondLeadingItem = secondLeadingItem
        self.trailingItem = trailingItem
        self.secondTrailingItem = secondTrailingItem
    }
    
    var body: some View {
        HStack(spacing: Views.Constants.navigationBarHStackSpacing) {
            leadingItem()
                .frame(width: Views.Constants.navigationBarItemFrameSize,
                       height: Views.Constants.navigationBarItemFrameSize)
            
            secondLeadingItem()
                .frame(width: Views.Constants.navigationBarItemFrameSize,
                       height: Views.Constants.navigationBarItemFrameSize)
            
            Spacer()
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            trailingItem()
                .frame(width: Views.Constants.navigationBarItemFrameSize,
                       height: Views.Constants.navigationBarItemFrameSize)
            
            secondTrailingItem()
                .frame(width: Views.Constants.navigationBarItemFrameSize,
                       height: Views.Constants.navigationBarItemFrameSize)
        }
        .padding(.top, Views.Constants.navigationBarTopPadding)
        .padding()
        .background (
            .ultraThinMaterial,
            in: Rectangle()
        )
        .ignoresSafeArea(edges: [.top, .horizontal])
    }
}

#Preview {
    CustomNavigationBar(title: "Navigation Bar") {
        Button {
            
        } label: {
            Image(systemName: "gear")
        }
    } secondLeadingItem: {
        Button {
            
        } label: {
            Image(systemName: "gear")
        }
    } trailingItem: {
        Button {
            
        } label: {
            Image(systemName: "gear")
        }
    } secondTrailingItem: {
        Button {
            
        } label: {
            Image(systemName: "gear")
        }
    }

}

private extension Views {
    struct Constants {
        static let navigationBarHStackSpacing: CGFloat = 30
        static let navigationBarItemFrameSize: CGFloat = 20
        static let navigationBarTopPadding: CGFloat = 40
        static let navigationBarBackgroundCornerRadius: CGFloat = 10
    }
}
