enum SubscriptionPlan: String {
    case standard = "Standard"
    case premium = "Premium"
}

extension SubscriptionPlan: CaseIterable {
    static var allCases: [SubscriptionPlan] {
        [
            .standard,
            .premium
        ]
    }
}
