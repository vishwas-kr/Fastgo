//
//  PaymentMethod.swift
//  Fastgo
//
//  Created by vishwas on 2/14/26.
//

import Foundation

enum PaymentType: String, Codable {
    case bank
    case card
}

struct PaymentMethod: Codable, Identifiable {
    let id: String
    let userId: String
    let type: PaymentType
    let cardNumber: String?
    let cardHolderName: String?
    let expiryDate: String?
    let cvv: String?
    let bankName: String?
    let accountNumber: String?
    let ifscCode: String?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case type
        case cardNumber = "card_number"
        case cardHolderName = "card_holder_name"
        case expiryDate = "expiry_date"
        case cvv
        case bankName = "bank_name"
        case accountNumber = "account_number"
        case ifscCode = "ifsc_code"
        case createdAt = "created_at"
    }
}
