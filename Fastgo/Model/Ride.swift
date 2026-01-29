//
//  Ride.swift
//  Fastgo
//
//  Created by vishwas on 1/12/26.
//
import Foundation

enum RideStatus: String, Codable {
    case completed
    case upcoming
    case cancelled
}


struct RideStatusModel : Identifiable {
    let id = UUID()
    let location : String
    let date : String
    let fare : Double
    let status : RideStatus
}


struct Ride: Identifiable, Codable {
    let id: String
    let scooterId: String
    let status: RideStatus
    let startLatitude: Double
    let startLongitude: Double
    let endLatitude: Double
    let endLongitude: Double
    let startLocationName: String
    let endLocationName: String
    let distanceKm: Double
    let fareAmount: Double
    let promoCode: String?
    let rideDate: Date
    
    enum CodingKeys : String, CodingKey {
        case id
        case scooterId = "scooter_id"
        case status
        case startLatitude = "start_latitude"
        case startLongitude = "start_longitude"
        case endLatitude = "end_latitude"
        case endLongitude = "end_longitude"
        case startLocationName = "start_location_name"
        case endLocationName = "end_location_name"
        case distanceKm = "distance_km"
        case fareAmount = "fare_amount"
        case promoCode
        case rideDate = "ride_date"
    }
}
