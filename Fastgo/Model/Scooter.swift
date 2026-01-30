//
//  Scooter.swift
//  Fastgo
//
//  Created by vishwas on 1/29/26.
//
import CoreLocation
import SwiftUI

enum ScooterType: String, Codable, CaseIterable {
    case sports
    case offroad
    case seated
    case standup
}

enum ScooterStatus: String, Codable {
    case available
    case reserved
    case inUse = "in_use"
    case maintenance
    case offline
}

struct ScooterDTO: Identifiable, Codable, Equatable {
    let id: String
    let uniqueCode: String
    let type: ScooterType
    
    let battery: Int
    let rangeKm: Int
    let perMinCost: Double
    let imageName: String
    
    let latitude: Double
    let longitude: Double
    
    let status: ScooterStatus
    let lastSeenAt: Date
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case uniqueCode = "unique_code"
        case type
        case battery
        case rangeKm = "range_km"
        case perMinCost = "per_min_cost"
        case imageName = "image_name"
        case latitude
        case longitude
        case status
        case lastSeenAt = "last_seen_at"
        case createdAt = "created_at"
    }
}


struct Scooter: Identifiable, Equatable {
    let id: String
    let uniqueCode: String
    let type: ScooterType
    
    let battery: Int
    let rangeKm: Int
    let perMinCost: Double
    
    let coordinate: CLLocationCoordinate2D
    let status: ScooterStatus
    
    static func == (lhs: Scooter, rhs: Scooter) -> Bool {
        lhs.id == rhs.id &&
        lhs.uniqueCode == rhs.uniqueCode &&
        lhs.type == rhs.type &&
        lhs.battery == rhs.battery &&
        lhs.rangeKm == rhs.rangeKm &&
        lhs.perMinCost == rhs.perMinCost &&
        lhs.status == rhs.status &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
    var typeName: String {
        "\(type.rawValue.capitalized) Scooter"
    }
    
    var batteryColor: Color {
        switch battery {
        case 80...100: return .green
        case 40..<80:  return .yellow
        default:       return .orange
        }
    }
}

extension Scooter {
    init(from dto: ScooterDTO) {
        self.id = dto.id
        self.uniqueCode = dto.uniqueCode
        self.type = dto.type
        self.battery = dto.battery
        self.rangeKm = dto.rangeKm
        self.perMinCost = dto.perMinCost
        self.coordinate = CLLocationCoordinate2D(latitude: dto.latitude, longitude: dto.longitude)
        self.status = dto.status
    }
    
    var imageName: String {
        switch type {
        case .offroad, .seated, .standup, .sports:
            return AssetImage.Scooter.scooter
        }
    }
}
