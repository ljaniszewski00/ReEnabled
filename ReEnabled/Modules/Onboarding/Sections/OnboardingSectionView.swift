import SwiftUI

struct OnboardingSectionView: View {
    let section: OnboardingSection
    let canDisplaySwipeToProceed: Bool
    let swipeToProceedOffset: CGSize
    let canDisplayActionCompletedAnimation: Bool
    
    var body: some View {
        VStack {
            ProgressIndicator(stepsNumber: OnboardingSection.allCases.count, activeStep: sectionNumber)
                .padding(.vertical)
                .padding(.bottom)
            
            VStack {
                if let title = section.title {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                
                Text(section.description)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .opacity(Views.Constants.sectionDescriptionOpacity)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical)
            }
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            ZStack(alignment: .bottomLeading) {
                HStack {
                    Spacer()
                    
                    if let imageResource = section.imageResource {
                        Image(imageResource.imageResource)
                            .resizable()
                            .scaledToFill()
                            .if(imageResource.applyBottomMask) {
                                $0
                                    .mask(LinearGradient(gradient: Gradient(stops: [
                                        .init(color: .black, location: 0),
                                        .init(color: .clear, location: 1),
                                        .init(color: .black, location: 1),
                                        .init(color: .clear, location: 1)
                                    ]), startPoint: .top, endPoint: .bottom))
                            }
                            .frame(width: imageResource.width,
                                   height: imageResource.height)
                    } else {
                        if canDisplayActionCompletedAnimation {
                            LottieView(name: LottieAssetName.actionCompletedWhite,
                                       loopMode: .playOnce)
                        } else {
                            if let lottieView = section.lottieView {
                                lottieView
                            }
                        }
                        
                    }
                    
                    Spacer()
                }
                .padding(.bottom, Views.Constants.imageBottomPadding)
                
                if !swipeToProceedHidden {
                    Views.swipeToProceed(offset: swipeToProceedOffset)
                }
            }
        }
        .padding()
        .contentShape(Rectangle())
        .background {
            Color.black
                .ignoresSafeArea()
        }
    }
    
    private var sectionNumber: Int {
        switch section {
        case .welcome:
            return 1
        case .gestures(_):
            return 2
        case .functions(_):
            return 3
        case .voiceCommands(_):
            return 4
        case .feedback(_):
            return 5
        case .ending:
            return 6
        }
    }
    
    private var swipeToProceedHidden: Bool {
        if !canDisplaySwipeToProceed {
            return true
        }
        
        switch section {
        case .welcome:
            return false
        case .gestures(let onboardingGesturesSection):
            switch onboardingGesturesSection {
            case .gesturesSectionWelcome:
                return false
            case .gesturesSectionEnding:
                return false
            default:
                return true
            }
        case .functions(_):
            return false
        case .voiceCommands(let onboardingVoiceCommandsSection):
            switch onboardingVoiceCommandsSection {
            case .voiceCommandsExplanation:
                return false
            case .voiceCommandsRemindGestures:
                return true
            case .voiceCommandsRemindVoiceCommands:
                return false
            }
        case .feedback(_):
            return false
        case .ending:
            return false
        }
    }
}

#Preview {
    OnboardingSectionView(section: .welcome,
                          canDisplaySwipeToProceed: true,
                          swipeToProceedOffset: .zero,
                          canDisplayActionCompletedAnimation: false)
}

private extension Views {
    struct Constants {
        static let mainVStackSpacing: CGFloat = 20
        static let titleTopPadding: CGFloat = 30
        static let sectionDescriptionOpacity: CGFloat = 0.5
        static let imageBottomPadding: CGFloat = 30
        static let swipeToProceedHStackSpacing: CGFloat = 20
        static let swipeToProceedImageName: String = "arrowshape.right.circle"
        static let swipeToProceedImageSize: CGFloat = 40
        static let swipeToProceedShimmerZoneHeight: CGFloat = 20
        static let swipeToProceedLabel: String = OnboardingText.swipeToProceed.rawValue.localized()
        static let swipeToProceedHStackPadding: CGFloat = 10
        static let swipeToProceedHStackHorizontalPadding: CGFloat = 10
    }
    
    struct swipeToProceed: View {
        let offset: CGSize
        
        var body: some View {
            HStack(spacing: Views.Constants.swipeToProceedHStackSpacing) {
                Image(systemName: Views.Constants.swipeToProceedImageName)
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: Views.Constants.swipeToProceedImageSize,
                           height: Views.Constants.swipeToProceedImageSize)
                    .offset(x: swipeToProceedImageXOffset)
                
                ShimmeringViewContent {
                    Text(Views.Constants.swipeToProceedLabel)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .opacity(swipeToProceedLabelOpacityValue)
                }
                .frame(height: Views.Constants.swipeToProceedShimmerZoneHeight)
                
                Spacer()
            }
            .padding(Views.Constants.swipeToProceedHStackPadding)
            .padding(.horizontal, Views.Constants.swipeToProceedHStackHorizontalPadding)
            .background(
                .ultraThinMaterial,
                in: Capsule()
            )
        }
        
        private var swipeToProceedImageXOffset: CGFloat {
            offset.width > 0 ? offset.width : 0
        }
        
        private var swipeToProceedLabelOpacityValue: CGFloat {
            1 - (offset.width / 100)
        }
    }
}
