//
//  ScooterServices.swift
//  Fastgo
//
//  Created by vishwas on 1/30/26.
//
import Supabase
import Foundation


class NavigationServices {
    static let shared = NavigationServices()
    private let client : SupabaseClient
    
    private init() {
        self.client = SupabaseService.shared.client
    }
    
    func fetchScooters() async throws -> [ScooterDTO]{
        try await client.from("scooters").select().eq("status", value: "available").execute().value
    }
    
    func fetchParking() async throws -> [Parking]{
        try await client.from("parking").select().execute().value
    }
}
