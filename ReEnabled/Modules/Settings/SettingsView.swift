import SwiftUI

struct SettingsView: View {
    @StateObject private var tabBarStateManager: TabBarStateManager = .shared
    @StateObject private var feedbackManager: FeedbackManager = .shared
    @StateObject private var voiceRecordingManager: VoiceRecordingManager = .shared
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()
    
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
                    Views.PremiumSubscriberSettingsSection()
                        .padding(.bottom, 30)
                    Views.DeleteConversationsButton()
                        .padding(.bottom, 10)
                    Views.RestoreDefaultSettingsButton()
                }
                .padding(.top)
                .padding(.bottom, Views.Constants.mainVStackBottomPadding)
            }
            .environmentObject(settingsViewModel)
        }
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
            SettingsSectionHeader(title: SettingName.defaultCameraMode.rawValue)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let defaultCameraModeCases: [CameraMode] = CameraMode.allCases
                
                VStack(spacing: 0) {
                    ForEach(defaultCameraModeCases, id: \.self) { cameraMode in
                        Button {
                            withAnimation {
                                settingsViewModel.changeDefaultCameraMode(to: cameraMode)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: cameraMode.rawValue,
                                                       isSelectedValue: currentSettings.defaultCameraMode == cameraMode,
                                                       isLastValue: defaultCameraModeCases.last == cameraMode)
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
            SettingsSectionHeader(title: SettingName.defaultDistanceMeasureUnit.rawValue)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let distanceMeasureUnitCases: [DistanceMeasureUnit] = DistanceMeasureUnit.allCases
                
                VStack(spacing: 0) {
                    ForEach(distanceMeasureUnitCases, id: \.self) { distanceMeasureUnit in
                        Button {
                            withAnimation {
                                settingsViewModel.changeDefaultDistanceMeasureUnit(to: distanceMeasureUnit)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: distanceMeasureUnit.rawValue,
                                                       isSelectedValue: currentSettings.defaultDistanceMeasureUnit == distanceMeasureUnit,
                                                       isLastValue: distanceMeasureUnitCases.last == distanceMeasureUnit)
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
            SettingsSectionHeader(title: SettingName.documentScannerLanguage.rawValue)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                
                VStack(spacing: 0) {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        Button {
                            withAnimation {
                                settingsViewModel.changeDocumentScannerLanguage(to: supportedLanguage)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: supportedLanguage.fullName,
                                                       isSelectedValue: currentSettings.documentScannerLanguage == supportedLanguage,
                                                       isLastValue: supportedLanguages.last == supportedLanguage)
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
            SettingsSectionHeader(title: SettingName.flashlightTriggerMode.rawValue)
            
            if let currentSettings = settingsViewModel.currentSettings {
                VStack(spacing: 0) {
                    Button {
                        withAnimation {
                            settingsViewModel.changeFlashlightTriggerMode(to: FlashlightTriggerMode.automatic)
                        }
                    } label: {
                        SettingsSectionDetailsTile(value: FlashlightTriggerMode.automatic.rawValue,
                                                   isSelectedValue: currentSettings.flashlightTriggerLightValue == nil,
                                                   isLastValue: false)
                    }
                    
                    ForEach(settingsViewModel.availableFlashlightTriggerValues, id: \.self) { flashlightTriggerValue in
                        Button {
                            withAnimation {
                                settingsViewModel.changeFlashlightTriggerMode(to: FlashlightTriggerMode.specificLightValue(flashlightTriggerValue))
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: "\(flashlightTriggerValue)",
                                                       isSelectedValue: currentSettings.flashlightTriggerLightValue == flashlightTriggerValue,
                                                       isLastValue: settingsViewModel.availableFlashlightTriggerValues.last == flashlightTriggerValue)
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
            SettingsSectionHeader(title: SettingName.speechSpeed.rawValue)
            
            if let currentSettings = settingsViewModel.currentSettings {
                VStack(spacing: 0) {
                    ForEach(settingsViewModel.availableSpeechSpeeds, id: \.self) { speechSpeed in
                        Button {
                            withAnimation {
                                settingsViewModel.changeSpeechSpeed(to: speechSpeed)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: "\(speechSpeed)",
                                                       isSelectedValue: currentSettings.speechSpeed == speechSpeed,
                                                       isLastValue: settingsViewModel.availableSpeechSpeeds.last == speechSpeed)
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
            SettingsSectionHeader(title: SettingName.speechVoiceType.rawValue)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let speechVoiceTypeCases: [SpeechVoiceType] = SpeechVoiceType.allCases
                
                VStack(spacing: 0) {
                    ForEach(speechVoiceTypeCases, id: \.self) { speechVoiceType in
                        Button {
                            withAnimation {
                                settingsViewModel.changeSpeechVoiceType(to: speechVoiceType)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: speechVoiceType.rawValue,
                                                       isSelectedValue: currentSettings.speechVoiceType == speechVoiceType,
                                                       isLastValue: speechVoiceTypeCases.last == speechVoiceType)
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
            SettingsSectionHeader(title: SettingName.speechLanguage.rawValue)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                
                VStack(spacing: 0) {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        Button {
                            withAnimation {
                                settingsViewModel.changeSpeechLanguage(to: supportedLanguage)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: supportedLanguage.fullName,
                                                       isSelectedValue: currentSettings.speechLanguage == supportedLanguage,
                                                       isLastValue: supportedLanguages.last == supportedLanguage)
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
            SettingsSectionHeader(title: SettingName.voiceRecordingLanguage.rawValue)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
                
                VStack(spacing: 0) {
                    ForEach(supportedLanguages, id: \.self) { supportedLanguage in
                        Button {
                            withAnimation {
                                settingsViewModel.changeVoiceRecordingLanguage(to: supportedLanguage)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: supportedLanguage.fullName,
                                                       isSelectedValue: currentSettings.voiceRecordingLanguage == supportedLanguage,
                                                       isLastValue: supportedLanguages.last == supportedLanguage)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Subscription Plan
    
    struct PremiumSubscriberSettingsSection: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            SettingsSectionHeader(title: SettingName.subscriptionPlan.rawValue)
            
            if let currentSettings = settingsViewModel.currentSettings {
                let subscriptionPlanCases: [SubscriptionPlan] = SubscriptionPlan.allCases
                
                VStack(spacing: 0) {
                    ForEach(subscriptionPlanCases, id: \.self) { subscriptionPlan in
                        Button {
                            withAnimation {
                                settingsViewModel.changeSubscriptionPlan(to: subscriptionPlan)
                            }
                        } label: {
                            SettingsSectionDetailsTile(value: subscriptionPlan.rawValue,
                                                       isSelectedValue: currentSettings.subscriptionPlan == subscriptionPlan,
                                                       isLastValue: subscriptionPlanCases.last == subscriptionPlan)
                        }
                    }
                }
            }
        }
    }
    
    struct SettingsSectionHeader: View {
        let title: String
        
        var body: some View {
            HStack {
                Text(title)
                    .font(.title2)
                Spacer()
            }
            .padding()
        }
    }
    
    struct SettingsSectionDetailsTile: View {
        let value: String
        let isSelectedValue: Bool
        let isLastValue: Bool
        
        var body: some View {
            VStack {
                HStack {
                    Text(value)
                        .font(.title3)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    if isSelectedValue {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                
                if !isLastValue {
                    Divider()
                }
            }
            .background {
                Rectangle()
                    .foregroundStyle(.regularMaterial)
                    .ignoresSafeArea()
            }
        }
    }
    
    struct DeleteConversationsButton: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            Button {
                _ = settingsViewModel.deleteAllConversations()
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Delete All Conversations")
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                }
                .padding()
                .background {
                    Rectangle()
                        .foregroundStyle(.red)
                        .ignoresSafeArea()
                }
            }
        }
    }
    
    struct RestoreDefaultSettingsButton: View {
        @EnvironmentObject private var settingsViewModel: SettingsViewModel
        
        var body: some View {
            Button {
                _ = settingsViewModel.restoreDefaultSettings()
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Restore Default Settings")
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                }
                .padding()
                .background {
                    Rectangle()
                        .foregroundStyle(.red)
                        .ignoresSafeArea()
                }
            }
        }
    }
}
