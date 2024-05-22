import RealmSwift
import SwiftUI

struct SettingsView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var voiceRequestor: VoiceRequestor = .shared
    
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()
    
    @ObservedResults(SettingsObject.self) var settingsObjects
    
    var body: some View {
        VStack(spacing: Views.Constants.mainVStackSpacing) {
            Views.navigationBar
            
            ScrollView(.vertical) {
                VStack(spacing: Views.Constants.sectionsVStackSpacing) {
                    Views.CameraModeSettingsSection()
                    Views.DistanceMeasureUnitSettingsSection()
                    Views.FlashlightTriggerModeSettingsSection()
                    Views.SpeechSpeedSettingsSection()
                    Views.SpeechVoiceSettingsSection()
                    Views.SubscriptionPlanSettingsSection()
                    Views.OtherSettingsSection()
                }
                .padding(.top)
                .padding(.bottom, Views.Constants.mainVStackBottomPadding)
            }
            .environmentObject(settingsViewModel)
            .onChange(of: settingsObjects) { _, updatedSettingsObjects in
                settingsViewModel.getSettings(from: updatedSettingsObjects)
            }
        }
        .onAppear {
            if tabBarStateManager.tabSelection == .settings {
                feedbackManager.generateSpeechFeedback(with: .other(.currentTab),
                                                       and: TabBarItem.settings.title)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    feedbackManager.generateSpeechFeedback(with: .settings(.welcomeHint))
                }
            }
        }
        .onChange(of: voiceRequestor.selectedVoiceRequest) { _, voiceRequest in
            guard voiceRequest != VoiceRequest.empty else {
                return
            }
            
            switch voiceRequest {
            case .settings(.changeDefaultCameraModeToMainRecognizer):
                settingsViewModel.changeDefaultCameraMode(to: .mainRecognizer)
            case .settings(.changeDefaultCameraModeToDocumentScanner):
                settingsViewModel.changeDefaultCameraMode(to: .documentScanner)
            case .settings(.changeDefaultCameraModeToColorDetector):
                settingsViewModel.changeDefaultCameraMode(to: .colorDetector)
            case .settings(.changeDefaultCameraModeToLightDetector):
                settingsViewModel.changeDefaultCameraMode(to: .lightDetector)
            case .settings(.changeDefaultDistanceMeasureUnitToCentimeters):
                settingsViewModel.changeDefaultDistanceMeasureUnit(to: .centimeters)
            case .settings(.changeDefaultDistanceMeasureUnitToMeters):
                settingsViewModel.changeDefaultDistanceMeasureUnit(to: .meters)
            case .settings(.changeFlashlightTriggerModeToAutomatic):
                settingsViewModel.changeFlashlightTriggerMode(to: .automatic)
            case .settings(.changeFlashlightTriggerModeToManualWithHighTolerance):
                settingsViewModel.changeFlashlightTriggerMode(to: .specificLightValue(.highestTolerance))
            case .settings(.changeFlashlightTriggerModeToManualWithMediumTolerance):
                settingsViewModel.changeFlashlightTriggerMode(to: .specificLightValue(.mediumTolerance))
            case .settings(.changeFlashlightTriggerModeToManualWithLowTolerance):
                settingsViewModel.changeFlashlightTriggerMode(to: .specificLightValue(.lowestTolerance))
            case .settings(.changeSpeechSpeedToFastest):
                settingsViewModel.changeSpeechSpeed(to: .fastest)
            case .settings(.changeSpeechSpeedToFaster):
                settingsViewModel.changeSpeechSpeed(to: .faster)
            case .settings(.changeSpeechSpeedToNormal):
                settingsViewModel.changeSpeechSpeed(to: .normal)
            case .settings(.changeSpeechSpeedToSlower):
                settingsViewModel.changeSpeechSpeed(to: .slower)
            case .settings(.changeSpeechSpeedToSlowest):
                settingsViewModel.changeSpeechSpeed(to: .slowest)
            case .settings(.changeSpeechVoiceTypeToFemale):
                settingsViewModel.changeSpeechVoiceType(to: .female)
            case .settings(.changeSpeechVoiceTypeToMale):
                settingsViewModel.changeSpeechVoiceType(to: .male)
            case .settings(.deleteAllConversations):
                settingsViewModel.deleteAllConversations()
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { _ in
                        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.allConversationsDeleted))
                    })
                    .store(in: &settingsViewModel.cancelBag)
            case .settings(.restoreDefaultSettings):
                settingsViewModel.restoreDefaultSettings()
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { _ in
                        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.restoredDefaultSettings))
                    })
                    .store(in: &settingsViewModel.cancelBag)
            case .other(.remindVoiceCommands):
                guard tabBarStateManager.tabSelection == .settings else {
                    voiceRequestor.selectedVoiceRequest = .empty
                    return
                }
                
                let actionScreen = ActionScreen(screenType: .settings)
                feedbackManager.generateVoiceRequestsReminder(for: actionScreen)
            case .other(.remindGestures):
                guard tabBarStateManager.tabSelection == .settings else {
                    voiceRequestor.selectedVoiceRequest = .empty
                    return
                }
                let actionScreen = ActionScreen(screenType: .settings)
                feedbackManager.generateGesturesReminder(for: actionScreen)
            default:
                voiceRequestor.selectedVoiceRequest = .empty
                return
            }
            
            voiceRequestor.selectedVoiceRequest = .empty
        }
        .addGesturesActions(toExecuteBeforeEveryAction: {
            feedbackManager.generateHapticFeedbackForSwipeAction()
        }, onSwipeFromLeftToRightAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.camera)
        }, onSwipeFromRightToLeftAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.chat)
        })
    }
}

#Preview {
    SettingsView()
}

private extension Views {
    struct Constants {
        static let mainVStackSpacing: CGFloat = 0
        static let sectionsVStackSpacing: CGFloat = 10
        static let navigationTitle: String = SettingsTabText.navigationTitle.rawValue.localized()
        static let mainVStackBottomPadding: CGFloat = 100
        
        static let otherSettingsSectionVStackSpacing: CGFloat = 15
        static let sectionInnerVStackSpacing: CGFloat = 0
        
        static let otherSettingsSectionDividerColorOpacity: CGFloat = 0.8
        static let otherSettingsSectionBackgroundCornerRadius: CGFloat = 15
        static let otherSettingsSectionBackgroundColorOpacity: CGFloat = 0.8
        
        static let settingsSectionHeaderVStackSpacing: CGFloat = 15
        
        static let settingsSectionDetailsVStackSpacing: CGFloat = 0
        static let settingsSectionDetailsBackgroundCornerRadius: CGFloat = 15
        static let settingsSectionDetailsBottomPadding: CGFloat = 10
        
        static let settingsSectionDetailsTileInnerVStackSpacing: CGFloat = 10
        static let settingsSectionDetailsTileInnerHStackSpacing: CGFloat = 8
        static let settingsSectionDetailsTileImageSize: CGFloat = 14
        static let settingsSectionDetailsTileIsSelectedImageName: String = "checkmark"
        static let settingsSectionDetailsTileIsSelectedImageSize: CGFloat = 15
        
        static let displayOnboardingButtonText: String = SettingsTabText.displayOnboarding.rawValue.localized()
        static let deleteConversationsButtonText: String = SettingsTabText.deleteAllConversations.rawValue.localized()
        static let restoreDefaultSettingsButtonText: String = SettingsTabText.restoreDefaultSettings.rawValue.localized()
    }
    
    static var navigationBar: some View {
        CustomNavigationBar(title: Views.Constants.navigationTitle)
    }
    
    // MARK: - Camera Mode
    
    struct CameraModeSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.defaultCameraMode.settingName,
                                  description: ApplicationSetting.defaultCameraMode.settingDescription)
                .addGesturesActions(onLongPress: {
                    voiceRecordingManager.manageTalking()
                })
            
            if let currentSettings = settingsViewModel.currentSettings {
                let defaultCameraModeCases: [CameraMode] = CameraMode.allCases
                
                Views.SettingsSectionDetails {
                    ForEach(defaultCameraModeCases, id: \.self) { cameraMode in
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                            SettingsSectionDetailsTile(value: cameraMode.rawValue,
                                                       isSelectedValue: currentSettings.defaultCameraMode == cameraMode)
                                .padding(.vertical)
                            
                            if defaultCameraModeCases.last != cameraMode {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                let speechText: String = "\(ApplicationSetting.defaultCameraMode.settingName) \(cameraMode)"
                                feedbackManager.generateSpeechFeedback(with: speechText)
                            }
                        }, onDoubleTap: {
                            settingsViewModel.changeDefaultCameraMode(to: cameraMode)
                        }, onTrippleTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                feedbackManager.generateSpeechFeedback(with: ApplicationSetting.defaultCameraMode.settingDescription)
                            }
                        }, onLongPress: {
                            voiceRecordingManager.manageTalking()
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - Distance Measure Unit
    
    struct DistanceMeasureUnitSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.defaultDistanceMeasureUnit.settingName,
                                  description: ApplicationSetting.defaultDistanceMeasureUnit.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let distanceMeasureUnitCases: [DistanceMeasureUnit] = DistanceMeasureUnit.allCases
                
                Views.SettingsSectionDetails {
                    ForEach(distanceMeasureUnitCases, id: \.self) { distanceMeasureUnit in
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                            SettingsSectionDetailsTile(value: distanceMeasureUnit.rawValue,
                                                       isSelectedValue: currentSettings.defaultDistanceMeasureUnit == distanceMeasureUnit)
                                .padding(.vertical)
                            
                            if distanceMeasureUnitCases.last != distanceMeasureUnit {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                let speechText: String = "\(ApplicationSetting.defaultDistanceMeasureUnit.settingName) \(distanceMeasureUnit)"
                                feedbackManager.generateSpeechFeedback(with: speechText)
                            }
                        }, onDoubleTap: {
                            settingsViewModel.changeDefaultDistanceMeasureUnit(to: distanceMeasureUnit)
                        }, onTrippleTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                feedbackManager.generateSpeechFeedback(with: ApplicationSetting.defaultDistanceMeasureUnit.settingDescription)
                            }
                        }, onLongPress: {
                            voiceRecordingManager.manageTalking()
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - Flashlight Trigger Mode
    
    struct FlashlightTriggerModeSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.flashlightTriggerMode.settingName,
                                  description: ApplicationSetting.flashlightTriggerMode.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                Views.SettingsSectionDetails {
                    let tileDescription: String = SettingsTabText.letDeviceManageFlashlightForItself.rawValue.localized()
                    VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                        SettingsSectionDetailsTile(value: FlashlightTriggerMode.automatic.rawValue,
                                                   description: tileDescription,
                                                   isSelectedValue: currentSettings.flashlightTriggerLightValue == nil)
                            .padding(.vertical)
                        
                        Divider()
                    }
                    .contentShape(Rectangle())
                    .addGesturesActions(toExecuteBeforeEveryAction: {
                        feedbackManager.generateHapticFeedbackForSwipeAction()
                    }, onTap: {
                        if feedbackManager.speechFeedbackIsBeingGenerated {
                            feedbackManager.stopSpeechFeedback()
                        } else {
                            let speechText: String = "\(ApplicationSetting.flashlightTriggerMode.settingName) \(FlashlightTriggerMode.automatic.rawValue) \(tileDescription)"
                            feedbackManager.generateSpeechFeedback(with: speechText)
                        }
                    }, onDoubleTap: {
                        settingsViewModel.changeFlashlightTriggerMode(to: FlashlightTriggerMode.automatic)
                    }, onTrippleTap: {
                        if feedbackManager.speechFeedbackIsBeingGenerated {
                            feedbackManager.stopSpeechFeedback()
                        } else {
                            feedbackManager.generateSpeechFeedback(with: ApplicationSetting.flashlightTriggerMode.settingDescription)
                        }
                    }, onLongPress: {
                        voiceRecordingManager.manageTalking()
                    })
                    
                    ForEach(ManualFlashlightTriggerValue.allCases, id: \.self) { flashlightTriggerValueKey in
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                            SettingsSectionDetailsTile(value: flashlightTriggerValueKey.rawValue,
                                                       description: flashlightTriggerValueKey.settingDescription,
                                                       isSelectedValue: currentSettings.flashlightTriggerLightValue == flashlightTriggerValueKey.flashlightTriggerValue)
                                .padding(.vertical)
                            
                            if ManualFlashlightTriggerValue.allCases.last != flashlightTriggerValueKey {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                let speechText: String = "\(ApplicationSetting.flashlightTriggerMode.settingName) \(flashlightTriggerValueKey) \(String(describing: tileDescription))"
                                feedbackManager.generateSpeechFeedback(with: speechText)
                            }
                        }, onDoubleTap: {
                            settingsViewModel.changeFlashlightTriggerMode(to: FlashlightTriggerMode.specificLightValue(flashlightTriggerValueKey))
                        }, onTrippleTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                feedbackManager.generateSpeechFeedback(with: ApplicationSetting.flashlightTriggerMode.settingDescription)
                            }
                        }, onLongPress: {
                            voiceRecordingManager.manageTalking()
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - Speech Speed
    
    struct SpeechSpeedSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.speechSpeed.settingName,
                                  description: ApplicationSetting.speechSpeed.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                Views.SettingsSectionDetails {
                    ForEach(SpeechSpeed.allCases, id: \.self) { speechSpeedKey in
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                            SettingsSectionDetailsTile(value: speechSpeedKey.rawValue,
                                                       isSelectedValue: currentSettings.speechSpeed == speechSpeedKey.speed)
                                .padding(.vertical)
                            
                            if SpeechSpeed.allCases.last != speechSpeedKey {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                let speechText: String = "\(ApplicationSetting.speechSpeed.settingName) \(speechSpeedKey)"
                                feedbackManager.generateSpeechFeedback(with: speechText)
                            }
                        }, onDoubleTap: {
                            settingsViewModel.changeSpeechSpeed(to: speechSpeedKey)
                        }, onTrippleTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                feedbackManager.generateSpeechFeedback(with: ApplicationSetting.speechSpeed.settingDescription)
                            }
                            
                        }, onLongPress: {
                            voiceRecordingManager.manageTalking()
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - Speech Voice Type
    
    struct SpeechVoiceSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.speechVoiceType.settingName,
                                  description: ApplicationSetting.speechVoiceType.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings,
                let currentSpeechLanguage = getAppLanguage() {
                let speechVoiceTypeCases: [SpeechVoiceType] = currentSpeechLanguage.supportedSpeechVoiceTypes
                Views.SettingsSectionDetails {
                    ForEach(speechVoiceTypeCases, id: \.self) { speechVoiceType in
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                            SettingsSectionDetailsTile(value: speechVoiceType.rawValue,
                                                       description: speechVoiceType.getVoiceName(for: currentSpeechLanguage),
                                                       isSelectedValue: currentSettings.speechVoiceType == speechVoiceType)
                                .padding(.vertical)
                            
                            if speechVoiceTypeCases.last != speechVoiceType {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                let speechText: String = "\(ApplicationSetting.speechVoiceType.settingName) \(speechVoiceType)"
                                feedbackManager.generateSpeechFeedback(with: speechText)
                            }
                        }, onDoubleTap: {
                            settingsViewModel.changeSpeechVoiceType(to: speechVoiceType)
                        }, onTrippleTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                feedbackManager.generateSpeechFeedback(with: ApplicationSetting.speechVoiceType.settingDescription)
                            }
                        }, onLongPress: {
                            voiceRecordingManager.manageTalking()
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - Subscription Plan
    
    struct SubscriptionPlanSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.subscriptionPlan.settingName,
                                  description: ApplicationSetting.subscriptionPlan.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let subscriptionPlanCases: [SubscriptionPlan] = SubscriptionPlan.allCases
                Views.SettingsSectionDetails {
                    ForEach(subscriptionPlanCases, id: \.self) { subscriptionPlan in
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                            SettingsSectionDetailsTile(value: subscriptionPlan.rawValue,
                                                       imageName: subscriptionPlan == .premium ? "crown.fill" : nil,
                                                       imageColor: .yellow.opacity(0.9),
                                                       description: subscriptionPlan.description,
                                                       isSelectedValue: currentSettings.subscriptionPlan == subscriptionPlan)
                                .padding(.vertical)
                            
                            if subscriptionPlanCases.last != subscriptionPlan {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                let speechText: String = "\(ApplicationSetting.subscriptionPlan.settingName) \(subscriptionPlan) \(subscriptionPlan.description)"
                                feedbackManager.generateSpeechFeedback(with: speechText)
                            }
                        }, onDoubleTap: {
                            settingsViewModel.changeSubscriptionPlan(to: subscriptionPlan)
                        }, onTrippleTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                feedbackManager.generateSpeechFeedback(with: ApplicationSetting.subscriptionPlan.settingDescription)
                            }
                        }, onLongPress: {
                            voiceRecordingManager.manageTalking()
                        })
                    }
                }
            }
        }
    }
    
    struct OtherSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.others.settingName,
                                  description: nil)
            
            VStack(spacing: Views.Constants.otherSettingsSectionVStackSpacing) {
                Views.DisplayOnboardingButton()
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius:
                                            Views.Constants.otherSettingsSectionBackgroundCornerRadius)
                            .foregroundStyle(.thinMaterial)
                            .foregroundColor(
                                .blue.opacity(
                                    Views.Constants.otherSettingsSectionBackgroundColorOpacity
                                )
                            )
                            .ignoresSafeArea()
                    }
                    .padding(.horizontal)
                
                if settingsViewModel.currentSettings != nil {
                    VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                        Views.DeleteConversationsButton()
                            .padding(.vertical)
                        
                        Divider()
                        
                        Views.RestoreDefaultSettingsButton()
                            .padding(.vertical)
                    }
                    .padding(.horizontal)
                    .background {
                        RoundedRectangle(cornerRadius:
                                            Views.Constants.otherSettingsSectionBackgroundCornerRadius)
                            .foregroundStyle(.thinMaterial)
                            .foregroundColor(
                                .red.opacity(
                                    Views.Constants.otherSettingsSectionBackgroundColorOpacity
                                )
                            )
                            .foregroundStyle(.thinMaterial)
                            .ignoresSafeArea()
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    struct SettingsSectionHeader: View {
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        let title: String
        let description: String?
        
        var body: some View {
            VStack(spacing: Views.Constants.settingsSectionHeaderVStackSpacing) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                if let description = description {
                    HStack {
                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(.placeholder)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.trailing)
                }
            }
            .padding([.horizontal, .top])
            .padding(.leading)
            .padding(.bottom, Views.Constants.settingsSectionDetailsBottomPadding)
            .addGesturesActions(onLongPress: {
                voiceRecordingManager.manageTalking()
            })
        }
    }
    
    struct SettingsSectionDetails<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder contentBuilder: () -> Content) {
            self.content = contentBuilder()
        }
        
        var body: some View {
            VStack(spacing: Views.Constants.settingsSectionDetailsVStackSpacing) {
                content
            }
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius:
                                    Views.Constants.settingsSectionDetailsBackgroundCornerRadius)
                    .foregroundStyle(.thinMaterial)
                    .ignoresSafeArea()
            }
            .padding(.horizontal)
            .padding(.bottom, Views.Constants.settingsSectionDetailsBottomPadding)
        }
    }
    
    struct SettingsSectionDetailsTile: View {
        let value: String
        var imageName: String? = nil
        var imageColor: Color = .white
        var description: String? = nil
        let isSelectedValue: Bool
        
        var body: some View {
            VStack {
                HStack() {
                    VStack(alignment: .leading, 
                           spacing: Views.Constants.settingsSectionDetailsTileInnerVStackSpacing) {
                        HStack(spacing: Views.Constants.settingsSectionDetailsTileInnerHStackSpacing) {
                            Text(value)
                                .font(.title3)
                                .foregroundStyle(.white)
                            
                            if let imageName = imageName {
                                Image(systemName: imageName)
                                    .resizable()
                                    .frame(width: Views.Constants.settingsSectionDetailsTileImageSize,
                                           height: Views.Constants.settingsSectionDetailsTileImageSize)
                                    .foregroundColor(imageColor)
                            }
                        }
                        
                        if let description = description {
                            Text(description)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                                .padding(.trailing)
                        }
                    }
                    
                    Spacer()
                    
                    if isSelectedValue {
                        Image(systemName: Views.Constants.settingsSectionDetailsTileIsSelectedImageName)
                            .resizable()
                            .frame(width: Views.Constants.settingsSectionDetailsTileIsSelectedImageSize,
                                   height: Views.Constants.settingsSectionDetailsTileIsSelectedImageSize)
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding()
        }
    }
    
    struct DisplayOnboardingButton: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            HStack {
                Text(Views.Constants.displayOnboardingButtonText)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .contentShape(Rectangle())
            .padding()
            .addGesturesActions(toExecuteBeforeEveryAction: {
                feedbackManager.generateHapticFeedbackForSwipeAction()
            }, onTap: {
                if feedbackManager.speechFeedbackIsBeingGenerated {
                    feedbackManager.stopSpeechFeedback()
                } else {
                    feedbackManager.generateSpeechFeedback(with: .settings(.doubleTapToDisplayOnboarding))
                }
            }, onDoubleTap: {
                settingsViewModel.displayOnboarding()
            }, onLongPress: {
                voiceRecordingManager.manageTalking()
            })
        }
    }
    
    struct DeleteConversationsButton: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            HStack {
                Text(Views.Constants.deleteConversationsButtonText)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .contentShape(Rectangle())
            .padding()
            .addGesturesActions(toExecuteBeforeEveryAction: {
                feedbackManager.generateHapticFeedbackForSwipeAction()
            }, onTap: {
                if feedbackManager.speechFeedbackIsBeingGenerated {
                    feedbackManager.stopSpeechFeedback()
                } else {
                    feedbackManager.generateSpeechFeedback(with: .settings(.doubleTapToDeleteConversations))
                }
            }, onDoubleTap: {
                settingsViewModel.deleteAllConversations()
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { _ in
                        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.allConversationsDeleted))
                    })
                    .store(in: &settingsViewModel.cancelBag)
            }, onLongPress: {
                voiceRecordingManager.manageTalking()
            })
        }
    }
    
    struct RestoreDefaultSettingsButton: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            HStack {
                Text(Views.Constants.restoreDefaultSettingsButtonText)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .contentShape(Rectangle())
            .padding()
            .addGesturesActions(toExecuteBeforeEveryAction: {
                feedbackManager.generateHapticFeedbackForSwipeAction()
            }, onTap: {
                if feedbackManager.speechFeedbackIsBeingGenerated {
                    feedbackManager.stopSpeechFeedback()
                } else {
                    feedbackManager.generateSpeechFeedback(with: .settings(.doubleTapToRestoreDefaultSettings))
                }
            }, onDoubleTap: {
                settingsViewModel.restoreDefaultSettings()
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { _ in
                        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.restoredDefaultSettings))
                    })
                    .store(in: &settingsViewModel.cancelBag)
            }, onLongPress: {
                voiceRecordingManager.manageTalking()
            })
        }
    }
}
