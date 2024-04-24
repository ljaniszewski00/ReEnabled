import SwiftUI

struct OnboardingSectionView: View {
    let section: OnboardingSection
    let canDisplaySwipeToProceed: Bool
    
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
                }
                
                Text(section.description)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(Views.Constants.sectionDescriptionOpacity)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical)
            }
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            
            if let imageResource = section.imageResource {
                Image(imageResource)
                    .resizable()
                    .frame(width: Views.Constants.imageSize,
                           height: Views.Constants.imageSize)
                    .padding(.vertical)
            }
            
            Spacer()
            
            if !swipeToProceedHidden {
                HStack(spacing: Views.Constants.swipeToProceedHStackSpacing) {
                    Image(systemName: Views.Constants.swipeToProceedImageName)
                        .resizable()
                        .frame(width: Views.Constants.swipeToProceedImageSize,
                               height: Views.Constants.swipeToProceedImageSize)
                    
                    Text(Views.Constants.swipeToProceedLabel)
                        .font(.headline)
                    
                    Spacer()
                }
                .padding(.leading)
            }
        }
        .padding()
        .contentShape(Rectangle())
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
        case .functions(let onboardingFunctionsSection):
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
        case .feedback(let onboardingFeedbackSection):
            return false
        case .ending:
            return false
        }
    }
}

#Preview {
    OnboardingSectionView(section: .functions(.chatDatabaseTutorial),
                          canDisplaySwipeToProceed: true)
}

private extension Views {
    struct Constants {
        static let mainVStackSpacing: CGFloat = 20
        static let titleTopPadding: CGFloat = 30
        static let imageSize: CGFloat = 250
        static let sectionDescriptionOpacity: CGFloat = 0.5
        static let swipeToProceedHStackSpacing: CGFloat = 20
        static let swipeToProceedImageName: String = "arrowshape.right.circle"
        static let swipeToProceedImageSize: CGFloat = 40
        static let swipeToProceedLabel: String = "Swipe to Proceed"
    }
}
