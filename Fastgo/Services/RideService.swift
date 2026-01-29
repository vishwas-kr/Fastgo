//
//  RideService.swift
//  Fastgo
//
//  Created by vishwas on 1/29/26.
//
import Supabase
import Foundation

class RideService {
    static let shared = RideService()
    private let client : SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: APIConstants.project_URL)!,
            supabaseKey: APIConstants.projectAPI_KEY
        )
        print("Supabase RideService initialized ✅")
    }
    
    func fetchRides(userId: String) async throws -> [Ride]{
        try await client.from("rides").select().eq("id", value: userId).order("ride_date",ascending: false).execute().value
    }
    
    func createRide(userId: String, payload: Ride) async throws -> Ride {
        try await client.from("rides").insert(payload).select().single().execute().value
    }
}
