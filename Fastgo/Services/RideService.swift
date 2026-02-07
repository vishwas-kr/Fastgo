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
        self.client = SupabaseService.shared.client
    }
    
    func fetchRides(userId: String) async throws -> [Ride]{
        try await client.from("rides").select().eq("user_id", value: userId).order("created_at",ascending: false).execute().value
    }
    
    func createRide(userId: String, payload: Ride) async throws -> Ride {
        try await client.from("rides").insert(payload).select().single().execute().value
    }
    
    func updateRide(rideId: String, payload: RideUpdatePayload) async throws {
        try await client.from("rides").update(payload).eq("id", value: rideId).execute()
    }
    
    func updateRidePhoto(rideId: String, payload: RidePhotoUpdatePayload) async throws {
        try await client.from("rides").update(payload).eq("id", value: rideId).execute()
    }
}
