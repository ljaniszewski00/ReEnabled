import RealmSwift

enum SubscriptionPlan: PersistableEnum {
    case standard
    case premium
    
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case OtherText.subscriptionPlanStandard.rawValue.localized() : self = .standard
        case OtherText.subscriptionPlanPremium.rawValue.localized() : self = .premium
        default: return nil
        }
    }
}

extension SubscriptionPlan {
    var rawValue: String {
        switch self {
        case .standard:
            OtherText.subscriptionPlanStandard.rawValue.localized()
        case .premium:
            OtherText.subscriptionPlanPremium.rawValue.localized()
        }
    }
    
    var description: String {
        switch self {
        case .standard:
            return OtherText.subscriptionPlanStandardDescription.rawValue.localized()
        case .premium:
            return OtherText.subscriptionPlanPremiumDescription.rawValue.localized()
        }
    }
}

extension SubscriptionPlan: CaseIterable {
    static var allCases: [SubscriptionPlan] {
        [
            .standard,
            .premium
        ]
    }
}
