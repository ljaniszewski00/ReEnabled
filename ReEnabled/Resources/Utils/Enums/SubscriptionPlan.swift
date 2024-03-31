import RealmSwift

enum SubscriptionPlan: String, PersistableEnum {
    case standard = "Standard"
    case premium = "Premium"
}

extension SubscriptionPlan {
    var description: String {
        switch self {
        case .standard:
            return """
            - Free
            - Chat text requests per hour: 30
            - Chat image requests per hour: 10
            - Every response signs limit: 150
            """
        case .premium:
            return """
            - Paid: $2.99 per month
            - Chat text requests per hour: unlimited
            - Chat image requests per hour: unlimited
            - Every response signs limit: unlimited
            """
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
