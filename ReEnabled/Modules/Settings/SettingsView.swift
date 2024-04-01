import RealmSwift
import SwiftUI

struct SettingsView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()
    
    @ObservedResults(SettingsObject.self) var settingsObjects
    
    var body: some View {
        VStack(spacing: 0) {
            Views.navigationBar
            
            ScrollView(.vertical) {
                VStack {
                    Views.CameraModeSettingsSection()
                        .padding(.bottom, 10)
                    Views.DistanceMeasureUnitSettingsSection()
                        .padding(.bottom, 10)
                    Views.DocumentScannerLanguageSettingsSection()
                        .padding(.bottom, 10)
                    Views.FlashlightTriggerModeSettingsSection()
                        .padding(.bottom, 10)
                    Views.SpeechSpeedSettingsSection()
                        .padding(.bottom, 10)
                    Views.SpeechVoiceSettingsSection()
                        .padding(.bottom, 10)
                    Views.SpeechLanguageSettingsSection()
                        .padding(.bottom, 10)
                    Views.VoiceRecordingLanguageSettingsSection()
                        .padding(.bottom, 10)
                    Views.SubscriptionPlanSettingsSection()
                        .padding(.bottom, 10)
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
        static let navigationTitle: String = "Settings"
        static let mainVStackBottomPadding: CGFloat = 100
    }
    
    static var navigationBar: some View {
        CustomNavigationBar(title: Views.Constants.navigationTitle)
    }
    
    // MARK: - Camera Mode
    
    struct CameraModeSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.defaultCameraMode.settingName,
                                  description: ApplicationSetting.defaultCameraMode.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let defaultCameraModeCases: [CameraMode] = CameraMode.allCases
                
                Views.SettingsSectionDetails {
                    ForEach(defaultCameraModeCases, id: \.self) { cameraMode in
                        VStack(spacing: 0) {
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
                            let speechText: String = "\(ApplicationSetting.defaultCameraMode.settingName) \(cameraMode)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                        }, onDoubleTap: {
                            let speechText: String = "Changed \(ApplicationSetting.defaultCameraMode.settingName) to \(cameraMode)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                            settingsViewModel.changeDefaultCameraMode(to: cameraMode)
                        }, onLongPress: {
                            feedbackManager.generateSpeechFeedback(text: ApplicationSetting.defaultCameraMode.settingDescription)
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
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.defaultDistanceMeasureUnit.settingName,
                                  description: ApplicationSetting.defaultDistanceMeasureUnit.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let distanceMeasureUnitCases: [DistanceMeasureUnit] = DistanceMeasureUnit.allCases
                
                Views.SettingsSectionDetails {
                    ForEach(distanceMeasureUnitCases, id: \.self) { distanceMeasureUnit in
                        VStack(spacing: 0) {
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
                            let speechText: String = "\(ApplicationSetting.defaultDistanceMeasureUnit.settingName) \(distanceMeasureUnit)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                        }, onDoubleTap: {
                            let speechText: String = "Changed \(ApplicationSetting.defaultDistanceMeasureUnit.settingName) to \(distanceMeasureUnit)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                            settingsViewModel.changeDefaultDistanceMeasureUnit(to: distanceMeasureUnit)
                        }, onLongPress: {
                            feedbackManager.generateSpeechFeedback(text: ApplicationSetting.defaultDistanceMeasureUnit.settingDescription)
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - Document Scanner Language
    
    struct DocumentScannerLanguageSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.documentScannerLanguage.settingName,
                                  description: ApplicationSetting.documentScannerLanguage.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                
                Views.SettingsSectionDetails {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        VStack(spacing: 0) {
                            SettingsSectionDetailsTile(value: supportedLanguage.fullName,
                                                       isSelectedValue: currentSettings.documentScannerLanguage == supportedLanguage)
                                .padding(.vertical)
                            
                            if supportedLanguages.last != supportedLanguage {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            let speechText: String = "\(ApplicationSetting.documentScannerLanguage.settingName) \(supportedLanguage)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                        }, onDoubleTap: {
                            let speechText: String = "Changed \(ApplicationSetting.documentScannerLanguage.settingName) to \(supportedLanguage)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                            settingsViewModel.changeDocumentScannerLanguage(to: supportedLanguage)
                        }, onLongPress: {
                            feedbackManager.generateSpeechFeedback(text: ApplicationSetting.documentScannerLanguage.settingDescription)
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
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.flashlightTriggerMode.settingName,
                                  description: ApplicationSetting.flashlightTriggerMode.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                Views.SettingsSectionDetails {
                    let tileDescription: String = "Let device manage flashlight for itself"
                    VStack(spacing: 0) {
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
                        let speechText: String = "\(ApplicationSetting.flashlightTriggerMode.settingName) \(FlashlightTriggerMode.automatic.rawValue) \(tileDescription)"
                        feedbackManager.generateSpeechFeedback(text: speechText)
                    }, onDoubleTap: {
                        let speechText: String = "Changed \(ApplicationSetting.flashlightTriggerMode.settingName) to \(FlashlightTriggerMode.automatic.rawValue)"
                        feedbackManager.generateSpeechFeedback(text: speechText)
                        settingsViewModel.changeFlashlightTriggerMode(to: FlashlightTriggerMode.automatic)
                    }, onLongPress: {
                        feedbackManager.generateSpeechFeedback(text: ApplicationSetting.flashlightTriggerMode.settingDescription)
                    })
                    
                    ForEach(settingsViewModel.availableFlashlightTriggerValues, id: \.self) { flashlightTriggerValue in
                        var tileDescription: String? {
                            if settingsViewModel.availableFlashlightTriggerValues.first == flashlightTriggerValue {
                                return "Greater tolerance towards darkness"
                            } else if settingsViewModel.availableFlashlightTriggerValues.last == flashlightTriggerValue {
                                return "Smaller tolerance towards darkness"
                            } else {
                                return nil
                            }
                        }
                        
                        VStack(spacing: 0) {
                            SettingsSectionDetailsTile(value: "\(flashlightTriggerValue)",
                                                       description: tileDescription,
                                                       isSelectedValue: currentSettings.flashlightTriggerLightValue == flashlightTriggerValue)
                                .padding(.vertical)
                            
                            if settingsViewModel.availableFlashlightTriggerValues.last != flashlightTriggerValue {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            let speechText: String = "\(ApplicationSetting.flashlightTriggerMode.settingName) \(flashlightTriggerValue) \(String(describing: tileDescription))"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                        }, onDoubleTap: {
                            let speechText: String = "Changed \(ApplicationSetting.flashlightTriggerMode.settingName) to \(flashlightTriggerValue)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                            settingsViewModel.changeFlashlightTriggerMode(to: FlashlightTriggerMode.specificLightValue(flashlightTriggerValue))
                        }, onLongPress: {
                            feedbackManager.generateSpeechFeedback(text: ApplicationSetting.flashlightTriggerMode.settingDescription)
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
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.speechSpeed.settingName,
                                  description: ApplicationSetting.speechSpeed.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                Views.SettingsSectionDetails {
                    ForEach(settingsViewModel.availableSpeechSpeeds, id: \.self) { speechSpeed in
                        var tileDescription: String? {
                            if settingsViewModel.availableSpeechSpeeds.first == speechSpeed {
                                return "Fastest"
                            } else if settingsViewModel.availableSpeechSpeeds.last == speechSpeed {
                                return "Slowest"
                            } else {
                                return nil
                            }
                        }
                        
                        VStack(spacing: 0) {
                            SettingsSectionDetailsTile(value: "\(speechSpeed)",
                                                       description: tileDescription,
                                                       isSelectedValue: currentSettings.speechSpeed == speechSpeed)
                                .padding(.vertical)
                            
                            if settingsViewModel.availableSpeechSpeeds.last != speechSpeed {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            let speechText: String = "\(ApplicationSetting.speechSpeed.settingName) \(speechSpeed) \(String(describing: tileDescription))"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                        }, onDoubleTap: {
                            let speechText: String = "Changed \(ApplicationSetting.speechSpeed.settingName) to \(speechSpeed)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                            settingsViewModel.changeSpeechSpeed(to: speechSpeed)
                        }, onLongPress: {
                            feedbackManager.generateSpeechFeedback(text: ApplicationSetting.speechSpeed.settingDescription)
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
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.speechVoiceType.settingName,
                                  description: ApplicationSetting.speechVoiceType.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let currentSpeechLanguage = currentSettings.speechLanguage
                let speechVoiceTypeCases: [SpeechVoiceType] = currentSpeechLanguage.supportedSpeechVoiceTypes
                Views.SettingsSectionDetails {
                    ForEach(speechVoiceTypeCases, id: \.self) { speechVoiceType in
                        VStack(spacing: 0) {
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
                            let speechText: String = "\(ApplicationSetting.speechVoiceType.settingName) \(speechVoiceType)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                        }, onDoubleTap: {
                            let speechText: String = "Changed \(ApplicationSetting.speechVoiceType.settingName) to \(speechVoiceType)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                            settingsViewModel.changeSpeechVoiceType(to: speechVoiceType)
                        }, onLongPress: {
                            feedbackManager.generateSpeechFeedback(text: ApplicationSetting.speechVoiceType.settingDescription)
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - Speech Language
    
    struct SpeechLanguageSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.speechLanguage.settingName,
                                  description: ApplicationSetting.speechLanguage.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                Views.SettingsSectionDetails {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        VStack(spacing: 0) {
                            SettingsSectionDetailsTile(value: supportedLanguage.fullName,
                                                       isSelectedValue: currentSettings.speechLanguage == supportedLanguage)
                                .padding(.vertical)
                            
                            if supportedLanguages.last != supportedLanguage {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            let speechText: String = "\(ApplicationSetting.speechLanguage.settingName) \(supportedLanguage)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                        }, onDoubleTap: {
                            let speechText: String = "Changed \(ApplicationSetting.speechLanguage.settingName) to \(supportedLanguage)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                            settingsViewModel.changeSpeechLanguage(to: supportedLanguage)
                        }, onLongPress: {
                            feedbackManager.generateSpeechFeedback(text: ApplicationSetting.speechLanguage.settingDescription)
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - Voice Recording Language
    
    struct VoiceRecordingLanguageSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.voiceRecordingLanguage.settingName,
                                  description: ApplicationSetting.voiceRecordingLanguage.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                Views.SettingsSectionDetails {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        VStack(spacing: 0) {
                            SettingsSectionDetailsTile(value: supportedLanguage.fullName,
                                                       isSelectedValue: currentSettings.voiceRecordingLanguage == supportedLanguage)
                                .padding(.vertical)
                            
                            if supportedLanguages.last != supportedLanguage {
                                Divider()
                            }
                        }
                        .contentShape(Rectangle())
                        .addGesturesActions(toExecuteBeforeEveryAction: {
                            feedbackManager.generateHapticFeedbackForSwipeAction()
                        }, onTap: {
                            let speechText: String = "\(ApplicationSetting.voiceRecordingLanguage.settingName) \(supportedLanguage)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                        }, onDoubleTap: {
                            let speechText: String = "Changed \(ApplicationSetting.voiceRecordingLanguage.settingName) to \(supportedLanguage)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                            settingsViewModel.changeVoiceRecordingLanguage(to: supportedLanguage)
                        }, onLongPress: {
                            feedbackManager.generateSpeechFeedback(text: ApplicationSetting.voiceRecordingLanguage.settingDescription)
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
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.subscriptionPlan.settingName,
                                  description: ApplicationSetting.subscriptionPlan.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let subscriptionPlanCases: [SubscriptionPlan] = SubscriptionPlan.allCases
                Views.SettingsSectionDetails {
                    ForEach(subscriptionPlanCases, id: \.self) { subscriptionPlan in
                        VStack(spacing: 0) {
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
                            let speechText: String = "\(ApplicationSetting.subscriptionPlan.settingName) \(subscriptionPlan) \(subscriptionPlan.description)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                        }, onDoubleTap: {
                            let speechText: String = "Changed \(ApplicationSetting.subscriptionPlan.settingName) to \(subscriptionPlan)"
                            feedbackManager.generateSpeechFeedback(text: speechText)
                            settingsViewModel.changeSubscriptionPlan(to: subscriptionPlan)
                        }, onLongPress: {
                            feedbackManager.generateSpeechFeedback(text: ApplicationSetting.subscriptionPlan.settingDescription)
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
            
            if let currentSettings = settingsViewModel.currentSettings {
                VStack(spacing: 0) {
                    Views.DeleteConversationsButton()
                        .padding(.vertical)
                    
                    Divider()
                        .overlay(Color.white.opacity(0.8))
                    
                    Views.RestoreDefaultSettingsButton()
                        .padding(.vertical)
                }
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.red.opacity(0.8))
                        .ignoresSafeArea()
                }
                .padding(.horizontal)
            }
        }
    }
    
    struct SettingsSectionHeader: View {
        let title: String
        let description: String?
        
        var body: some View {
            VStack(spacing: 15) {
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
        }
    }
    
    struct SettingsSectionDetails<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder contentBuilder: () -> Content) {
            self.content = contentBuilder()
        }
        
        var body: some View {
            VStack(spacing: 0) {
                content
            }
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.thinMaterial)
                    .ignoresSafeArea()
            }
            .padding(.horizontal)
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
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Text(value)
                                .font(.title3)
                                .foregroundStyle(.white)
                            
                            if let imageName = imageName {
                                Image(systemName: imageName)
                                    .resizable()
                                    .frame(width: 14, height: 14)
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
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding()
        }
    }
    
    struct DeleteConversationsButton: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        
        var body: some View {
            HStack {
                Text("Delete All Conversations")
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .contentShape(Rectangle())
            .padding()
            .addGesturesActions(toExecuteBeforeEveryAction: {
                feedbackManager.generateHapticFeedbackForSwipeAction()
            }, onTap: {
                let speechText: String = "Double tap to delete conversations"
                feedbackManager.generateSpeechFeedback(text: speechText)
            }, onDoubleTap: {
                let speechText: String = "Deleted conversations"
                feedbackManager.generateSpeechFeedback(text: speechText)
                _ = settingsViewModel.deleteAllConversations()
            })
        }
    }
    
    struct RestoreDefaultSettingsButton: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        
        var body: some View {
            HStack {
                Text("Restore Default Settings")
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .contentShape(Rectangle())
            .padding()
            .addGesturesActions(toExecuteBeforeEveryAction: {
                feedbackManager.generateHapticFeedbackForSwipeAction()
            }, onTap: {
                let speechText: String = "Double tap to restore default settings"
                feedbackManager.generateSpeechFeedback(text: speechText)
            }, onDoubleTap: {
                let speechText: String = "Restored default settings"
                feedbackManager.generateSpeechFeedback(text: speechText)
                _ = settingsViewModel.restoreDefaultSettings()
            })
        }
    }
}
