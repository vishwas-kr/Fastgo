//
//  PaymentService.swift
//  Fastgo
//
//  Created by vishwas on 2/14/26.
//

import Supabase
import Foundation

class PaymentService {
    static let shared = PaymentService()
    private let client: SupabaseClient
    
    private init() {
        self.client = SupabaseService.shared.client
    }
    
    func fetchPaymentMethods(userId: String) async throws -> [PaymentMethod] {
        try await client.from("payment_methods").select().eq("user_id", value: userId).order("created_at", ascending: false).execute().value
    }
    
    func addPaymentMethod(payload: PaymentMethod) async throws -> PaymentMethod {
        try await client.from("payment_methods").insert(payload).select().single().execute().value
    }
    
    func deletePaymentMethod(id: String) async throws {
        try await client.from("payment_methods").delete().eq("id", value: id).execute()
    }
}
