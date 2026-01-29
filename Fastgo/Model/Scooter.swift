//
//  Scooter.swift
//  Fastgo
//
//  Created by vishwas on 1/29/26.
//
import CoreLocation

enum ScooterType: String, Codable, CaseIterable {
    case sports, offroad, seated, standup
}

struct ScooterDetails: Identifiable, Codable, Equatable {
    let id: String
    let type: ScooterType
    let battery: Int
    let rangeKm: Int
    let perMinCost: Double
    let imageName: String
    let latitude: Double
    let longitude: Double
    let isAvailable: Bool

    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
