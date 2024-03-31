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
            
        }, toExecuteAfterEveryAction: {
            
        }, onTap: {
            
        }, onDoubleTap: {
            
        }, onLongPress: {
            
        }, onSwipeFromLeftToRight: {
            
        }, onSwipeFromRightToLeft: {
            
        }, onSwipeFromUpToDown: {
            
        }, onSwipeFromDownToUp: {
            
        }, onSwipeFromLeftToRightAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.camera)
        }, onSwipeFromRightToLeftAfterLongPress: {
            tabBarStateManager.changeTabSelectionTo(.chat)
        }, onSwipeFromUpToDownAfterLongPress: {
            
        }, onSwipeFromDownToUpAfterLongPress: {
            
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
        CustomNavigationBar(title: Views.Constants.navigationTitle,
                            leadingItem: {
            Text("")
        },
                            secondLeadingItem: {
            Text("")
        },
                            trailingItem: {
            Text("")
        },
                            secondTrailingItem: {
            Text("")
        })
    }
    
    // MARK: - Camera Mode
    
    struct CameraModeSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.defaultCameraMode.settingName,
                                  description: ApplicationSetting.defaultCameraMode.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let defaultCameraModeCases: [CameraMode] = CameraMode.allCases
                
                Views.SettingsSectionDetails {
                    ForEach(defaultCameraModeCases, id: \.self) { cameraMode in
                        Button {
                            withAnimation {
                                settingsViewModel.changeDefaultCameraMode(to: cameraMode)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: cameraMode.rawValue,
                                                       isSelectedValue: currentSettings.defaultCameraMode == cameraMode)
                        }
                        .padding(.vertical)
                        
                        if defaultCameraModeCases.last != cameraMode {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Distance Measure Unit
    
    struct DistanceMeasureUnitSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.defaultDistanceMeasureUnit.settingName,
                                  description: ApplicationSetting.defaultDistanceMeasureUnit.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let distanceMeasureUnitCases: [DistanceMeasureUnit] = DistanceMeasureUnit.allCases
                
                Views.SettingsSectionDetails {
                    ForEach(distanceMeasureUnitCases, id: \.self) { distanceMeasureUnit in
                        Button {
                            withAnimation {
                                settingsViewModel.changeDefaultDistanceMeasureUnit(to: distanceMeasureUnit)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: distanceMeasureUnit.rawValue,
                                                       isSelectedValue: currentSettings.defaultDistanceMeasureUnit == distanceMeasureUnit)
                        }
                        .padding(.vertical)
                        
                        if distanceMeasureUnitCases.last != distanceMeasureUnit {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Document Scanner Language
    
    struct DocumentScannerLanguageSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.documentScannerLanguage.settingName,
                                  description: ApplicationSetting.documentScannerLanguage.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                
                Views.SettingsSectionDetails {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        Button {
                            withAnimation {
                                settingsViewModel.changeDocumentScannerLanguage(to: supportedLanguage)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: supportedLanguage.fullName,
                                                       isSelectedValue: currentSettings.documentScannerLanguage == supportedLanguage)
                        }
                        .padding(.vertical)
                        
                        if supportedLanguages.last != supportedLanguage {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Flashlight Trigger Mode
    
    struct FlashlightTriggerModeSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.flashlightTriggerMode.settingName,
                                  description: ApplicationSetting.flashlightTriggerMode.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                Views.SettingsSectionDetails {
                    Button {
                        withAnimation {
                            settingsViewModel.changeFlashlightTriggerMode(to: FlashlightTriggerMode.automatic)
                        }
                    } label: {
                        SettingsSectionDetailsTile(value: FlashlightTriggerMode.automatic.rawValue,
                                                   description: "Let device manage flashlight for itself",
                                                   isSelectedValue: currentSettings.flashlightTriggerLightValue == nil)
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
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
                        
                        Button {
                            withAnimation {
                                settingsViewModel.changeFlashlightTriggerMode(to: FlashlightTriggerMode.specificLightValue(flashlightTriggerValue))
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: "\(flashlightTriggerValue)",
                                                       description: tileDescription,
                                                       isSelectedValue: currentSettings.flashlightTriggerLightValue == flashlightTriggerValue)
                        }
                        .padding(.vertical)
                        
                        if settingsViewModel.availableFlashlightTriggerValues.last != flashlightTriggerValue {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Speech Speed
    
    struct SpeechSpeedSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
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
                        
                        Button {
                            withAnimation {
                                settingsViewModel.changeSpeechSpeed(to: speechSpeed)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: "\(speechSpeed)",
                                                       description: tileDescription,
                                                       isSelectedValue: currentSettings.speechSpeed == speechSpeed)
                        }
                        .padding(.vertical)
                        
                        if settingsViewModel.availableSpeechSpeeds.last != speechSpeed {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Speech Voice Type
    
    struct SpeechVoiceSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.speechVoiceType.settingName,
                                  description: ApplicationSetting.speechVoiceType.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let speechVoiceTypeCases: [SpeechVoiceType] = SpeechVoiceType.allCases
                Views.SettingsSectionDetails {
                    ForEach(speechVoiceTypeCases, id: \.self) { speechVoiceType in
                        Button {
                            withAnimation {
                                settingsViewModel.changeSpeechVoiceType(to: speechVoiceType)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: speechVoiceType.rawValue,
                                                       isSelectedValue: currentSettings.speechVoiceType == speechVoiceType)
                        }
                        .padding(.vertical)
                        
                        if speechVoiceTypeCases.last != speechVoiceType {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Speech Language
    
    struct SpeechLanguageSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.speechLanguage.settingName,
                                  description: ApplicationSetting.speechLanguage.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                Views.SettingsSectionDetails {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        Button {
                            withAnimation {
                                settingsViewModel.changeSpeechLanguage(to: supportedLanguage)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: supportedLanguage.fullName,
                                                       isSelectedValue: currentSettings.speechLanguage == supportedLanguage)
                        }
                        .padding(.vertical)
                        
                        if supportedLanguages.last != supportedLanguage {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Voice Recording Language
    
    struct VoiceRecordingLanguageSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.voiceRecordingLanguage.settingName,
                                  description: ApplicationSetting.voiceRecordingLanguage.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                Views.SettingsSectionDetails {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        Button {
                            withAnimation {
                                settingsViewModel.changeVoiceRecordingLanguage(to: supportedLanguage)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: supportedLanguage.fullName,
                                                       isSelectedValue: currentSettings.voiceRecordingLanguage == supportedLanguage)
                        }
                        .padding(.vertical)
                        
                        if supportedLanguages.last != supportedLanguage {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Subscription Plan
    
    struct SubscriptionPlanSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            SettingsSectionHeader(title: ApplicationSetting.subscriptionPlan.settingName,
                                  description: ApplicationSetting.subscriptionPlan.settingDescription)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let subscriptionPlanCases: [SubscriptionPlan] = SubscriptionPlan.allCases
                Views.SettingsSectionDetails {
                    ForEach(subscriptionPlanCases, id: \.self) { subscriptionPlan in
                        Button {
                            withAnimation {
                                settingsViewModel.changeSubscriptionPlan(to: subscriptionPlan)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: subscriptionPlan.rawValue,
                                                       imageName: subscriptionPlan == .premium ? "crown.fill" : nil,
                                                       imageColor: .yellow.opacity(0.9),
                                                       description: subscriptionPlan.description,
                                                       isSelectedValue: currentSettings.subscriptionPlan == subscriptionPlan)
                        }
                        .padding(.vertical)
                        
                        if subscriptionPlanCases.last != subscriptionPlan {
                            Divider()
                        }
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
        
        var body: some View {
            Button {
                _ = settingsViewModel.deleteAllConversations()
            } label: {
                HStack {
                    Text("Delete All Conversations")
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    struct RestoreDefaultSettingsButton: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            Button {
                _ = settingsViewModel.restoreDefaultSettings()
            } label: {
                HStack {
                    Text("Restore Default Settings")
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}
