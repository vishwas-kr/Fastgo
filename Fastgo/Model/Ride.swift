//
//  Ride.swift
//  Fastgo
//
//  Created by vishwas on 1/12/26.
//
import Foundation

enum RideStatus: String, Codable {
    case reserved
    case inProgress = "in_progress"
    case completed
    case cancelled
}


struct RideStatusModel : Identifiable {
    let id = UUID()
    let location : String
    let date : String
    let fare : Double
    let status : RideStatus
}


//struct Ride: Identifiable, Codable {
//    let id: String
//    let scooterId: String
//    let status: RideStatus
//    let startLatitude: Double
//    let startLongitude: Double
//    let endLatitude: Double
//    let endLongitude: Double
//    let startLocationName: String
//    let endLocationName: String
//    let distanceKm: Double
//    let fareAmount: Double
//    let promoCode: String?
//    let rideDate: Date
//    
//    enum CodingKeys : String, CodingKey {
//        case id
//        case scooterId = "scooter_id"
//        case status
//        case startLatitude = "start_latitude"
//        case startLongitude = "start_longitude"
//        case endLatitude = "end_latitude"
//        case endLongitude = "end_longitude"
//        case startLocationName = "start_location_name"
//        case endLocationName = "end_location_name"
//        case distanceKm = "distance_km"
//        case fareAmount = "fare_amount"
//        case promoCode
//        case rideDate = "ride_date"
//    }
//}

struct Ride: Identifiable, Codable {
    let id: String
    let userId: String
    let scooterId: String

    let status: RideStatus

    let startLatitude: Double
    let startLongitude: Double
    let endLatitude: Double?
    let endLongitude: Double?

    let startLocationName: String?
    let endLocationName: String?

    let startedAt: Date?
    let endedAt: Date?

    let durationMinutes: Int?
    let distanceKm: Double?

    let totalFare: Double

    let promoCode: String?
    let discountAmount: Double?

    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case scooterId = "scooter_id"
        case status
        case startLatitude = "start_latitude"
        case startLongitude = "start_longitude"
        case endLatitude = "end_latitude"
        case endLongitude = "end_longitude"
        case startLocationName = "start_location_name"
        case endLocationName = "end_location_name"
        case startedAt = "started_at"
        case endedAt = "ended_at"
        case durationMinutes = "duration_minutes"
        case distanceKm = "distance_km"
        case totalFare = "total_fare"
        case promoCode = "promo_code"
        case discountAmount = "discount_amount"
        case createdAt = "created_at"
    }
}

//struct ActiveRide {
//    let rideId: UUID
//    let scooter: Scooter
//
//    let startedAt: Date
//    let startCoordinate: CLLocationCoordinate2D
//
//    var currentCoordinate: CLLocationCoordinate2D
//    var distanceTravelledKm: Double
//    var durationMinutes: Int
//
//    var batteryRemaining: Int
//}

struct RideHistoryItem: Identifiable {
    let id: String
    let scooterType: ScooterType
    let status: RideStatus
    let distanceKm: Double?
    let durationMinutes: Int?
    let totalFare: Double
    let date: Date
}
