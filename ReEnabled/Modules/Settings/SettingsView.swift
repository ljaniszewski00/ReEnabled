import RealmSwift
import SwiftUI

struct SettingsView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()
    
    @ObservedResults(SettingsObject.self) var settingsObjects
    
    var body: some View {
        VStack(spacing: Views.Constants.mainVStackSpacing) {
            Views.navigationBar
            
            ScrollView(.vertical) {
                VStack(spacing: Views.Constants.sectionsVStackSpacing) {
                    Views.CameraModeSettingsSection()
                    Views.DistanceMeasureUnitSettingsSection()
                    Views.DocumentScannerLanguageSettingsSection()
                    Views.FlashlightTriggerModeSettingsSection()
                    Views.SpeechSpeedSettingsSection()
                    Views.SpeechVoiceSettingsSection()
                    Views.SpeechLanguageSettingsSection()
                    Views.VoiceRecordingLanguageSettingsSection()
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
        static let navigationTitle: String = "Settings"
        static let mainVStackBottomPadding: CGFloat = 100
        
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
        
        static let deleteConversationsButtonText: String = "Delete All Conversations"
        static let restoreDefaultSettingsButtonText: String = "Restore Default Settings"
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
    
    // MARK: - Document Scanner Language
    
    struct DocumentScannerLanguageSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.documentScannerLanguage.settingName,
                                  description: ApplicationSetting.documentScannerLanguage.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                
                Views.SettingsSectionDetails {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
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
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                let speechText: String = "\(ApplicationSetting.documentScannerLanguage.settingName) \(supportedLanguage)"
                                feedbackManager.generateSpeechFeedback(with: speechText)
                            }
                        }, onDoubleTap: {
                            settingsViewModel.changeDocumentScannerLanguage(to: supportedLanguage)
                        }, onTrippleTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                feedbackManager.generateSpeechFeedback(with: ApplicationSetting.documentScannerLanguage.settingDescription)
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
                    let tileDescription: String = "Let device manage flashlight for itself"
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
                        feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.flashlightTriggerModeHasBeenSetTo),
                                                               and: FlashlightTriggerMode.automatic.rawValue)
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
                    
                    ForEach(settingsViewModel.availableFlashlightTriggerValuesKeys, id: \.self) { flashlightTriggerValueKey in
                        var tileDescription: String? {
                            if settingsViewModel.availableFlashlightTriggerValuesKeys.first == flashlightTriggerValueKey {
                                return "Highest tolerance towards darkness"
                            } else if settingsViewModel.availableFlashlightTriggerValuesKeys.last == flashlightTriggerValueKey {
                                return "Lowest tolerance towards darkness"
                            } else {
                                return nil
                            }
                        }
                        
                        let flashlightTriggerValue: Float = settingsViewModel.availableFlashlightTriggerValues[flashlightTriggerValueKey]!
                        
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                            SettingsSectionDetailsTile(value: flashlightTriggerValueKey,
                                                       description: tileDescription,
                                                       isSelectedValue: currentSettings.flashlightTriggerLightValue == flashlightTriggerValue)
                                .padding(.vertical)
                            
                            if settingsViewModel.availableFlashlightTriggerValuesKeys.last != flashlightTriggerValueKey {
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
                            feedbackManager.generateSpeechFeedback(with: SpeechFeedback.settings(.flashlightTriggerModeHasBeenSetTo),
                                                                   and: flashlightTriggerValueKey)
                            settingsViewModel.changeFlashlightTriggerMode(to: FlashlightTriggerMode.specificLightValue(flashlightTriggerValue))
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
                    ForEach(settingsViewModel.availableSpeechSpeedsKeys, id: \.self) { speechSpeedKey in
                        let speechSpeedValue: Float = settingsViewModel.availableSpeechSpeeds[speechSpeedKey]!
                        
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                            SettingsSectionDetailsTile(value: speechSpeedKey,
                                                       isSelectedValue: currentSettings.speechSpeed == speechSpeedValue)
                                .padding(.vertical)
                            
                            if settingsViewModel.availableSpeechSpeedsKeys.last != speechSpeedKey {
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
                            settingsViewModel.changeSpeechSpeed(to: speechSpeedValue, labeled: speechSpeedKey)
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
            
            if let currentSettings = settingsViewModel.currentSettings {
                let currentSpeechLanguage = currentSettings.speechLanguage
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
    
    // MARK: - Speech Language
    
    struct SpeechLanguageSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.speechLanguage.settingName,
                                  description: ApplicationSetting.speechLanguage.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                Views.SettingsSectionDetails {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
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
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                let speechText: String = "\(ApplicationSetting.speechLanguage.settingName) \(supportedLanguage)"
                                feedbackManager.generateSpeechFeedback(with: speechText)
                            }
                        }, onDoubleTap: {
                            settingsViewModel.changeSpeechLanguage(to: supportedLanguage)
                        }, onTrippleTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                feedbackManager.generateSpeechFeedback(with: ApplicationSetting.speechLanguage.settingDescription)
                            }
                        }, onLongPress: {
                            voiceRecordingManager.manageTalking()
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
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.voiceRecordingLanguage.settingName,
                                  description: ApplicationSetting.voiceRecordingLanguage.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                Views.SettingsSectionDetails {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
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
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                let speechText: String = "\(ApplicationSetting.voiceRecordingLanguage.settingName) \(supportedLanguage)"
                                feedbackManager.generateSpeechFeedback(with: speechText)
                            }
                        }, onDoubleTap: {
                            settingsViewModel.changeVoiceRecordingLanguage(to: supportedLanguage)
                        }, onTrippleTap: {
                            if feedbackManager.speechFeedbackIsBeingGenerated {
                                feedbackManager.stopSpeechFeedback()
                            } else {
                                feedbackManager.generateSpeechFeedback(with: ApplicationSetting.voiceRecordingLanguage.settingDescription)
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
            
            if settingsViewModel.currentSettings != nil {
                VStack(spacing: Views.Constants.sectionInnerVStackSpacing) {
                    Views.DeleteConversationsButton()
                        .padding(.vertical)
                    
                    Divider()
                        .overlay(
                            Color.white.opacity(
                                Views.Constants.otherSettingsSectionDividerColorOpacity
                            )
                        )
                    
                    Views.RestoreDefaultSettingsButton()
                        .padding(.vertical)
                }
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius:
                                        Views.Constants.otherSettingsSectionBackgroundCornerRadius)
                        .foregroundStyle(
                            .red.opacity(
                                Views.Constants.otherSettingsSectionBackgroundColorOpacity
                            )
                        )
                        .ignoresSafeArea()
                }
                .padding(.horizontal)
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
    
    struct DeleteConversationsButton: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        @StateObject private var feedbackManager: FeedbackManager = .shared
        @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
        
        var body: some View {
            HStack {
                Text(Views.Constants.deleteConversationsButtonText)
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
                    let speechText: String = "Double tap to delete conversations"
                    feedbackManager.generateSpeechFeedback(with: speechText)
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
                    let speechText: String = "Double tap to restore default settings"
                    feedbackManager.generateSpeechFeedback(with: speechText)
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
