//
//  ScooterServices.swift
//  Fastgo
//
//  Created by vishwas on 1/30/26.
//
import Supabase
import Foundation


class ScooterServices {
    static let shared = ScooterServices()
    private let client : SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: APIConstants.project_URL)!,
            supabaseKey: APIConstants.projectAPI_KEY
        )
        print("Supabase Scooter Services initialized ✅")
    }
    
    func fetchScooters() async throws -> [ScooterDTO]{
        try await client.from("scooters").select().eq("status", value: "available").execute().value
    }
}
