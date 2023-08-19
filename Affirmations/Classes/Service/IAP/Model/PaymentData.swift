//
//  PaymentData.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 19.08.2023.
//

struct PaymentData: Codable {
    let subscriptions: [SubscriptionPaymentProduct]
    let nonConsumables: [NonConsumablePaymentProduct]
}

struct SubscriptionPaymentProduct: Codable {
    enum Status: String, Codable {
        case refund, trial, paid
    }
    
    let productID: String
    let valid: Bool
    let expiration: String
    let status: Status
    let renewing: Bool
}

struct NonConsumablePaymentProduct: Codable {
    let productID: String
    let valid: Bool
}
