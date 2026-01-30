//
//  RideAnnotation.swift
//  Fastgo
//
//  Created by vishwas on 1/17/26.
//
import SwiftUI
import MapKit

//// The new ScooterType enum as requested.
//// Making it Codable allows for easy conversion from/to JSON.
//enum ScooterType: String, Codable, CaseIterable {
//    case sports, offroad, seated, standup
//}

// This struct groups all vehicle-specific details as you requested.
//struct VehicleDetails: Equatable {
//    let type: ScooterType
//    let battery: Int
//    let range: Int
//    let perMinCost: Double
//    let imageName: String
//    let coordinates: CLLocationCoordinate2D
//    
//    static func == (lhs: VehicleDetails, rhs: VehicleDetails) -> Bool {
//        lhs.type == rhs.type &&
//        lhs.battery == rhs.battery &&
//        lhs.range == rhs.range &&
//        lhs.perMinCost == rhs.perMinCost &&
//        lhs.imageName == rhs.imageName &&
//        lhs.coordinates.latitude == rhs.coordinates.latitude &&
//        lhs.coordinates.longitude == rhs.coordinates.longitude
//    }
//}
//
//struct RideAnnotation: Identifiable, Equatable {
//    // By making RideAnnotation Equatable, we can more easily manage selections.
//    static func == (lhs: RideAnnotation, rhs: RideAnnotation) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    let id = UUID()
//    let title: String
//    let vehicleDetails: VehicleDetails
//    
//    // Convenience computed properties for easy access in views
//    var coordinates: CLLocationCoordinate2D { vehicleDetails.coordinates }
//    var battery: Int { vehicleDetails.battery }
//    var range: Int { vehicleDetails.range }
//    var image: String { vehicleDetails.imageName }
//    var perMinCost: Double { vehicleDetails.perMinCost }
//    var typeName: String { vehicleDetails.type.rawValue.capitalized + " Scooter" }
//    
//    // The powerColor can be derived from the battery level for dynamic UI.
//    var powerColor: Color {
//        switch vehicleDetails.battery {
//        case 81...100:
//            return .green
//        case 31...80:
//            return .yellow
//        default:
//            return .orange
//        }
//    }
//}

struct ScooterAnnotation: Identifiable, Equatable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let scooter: Scooter

    static func == (lhs: ScooterAnnotation, rhs: ScooterAnnotation) -> Bool {
        lhs.id == rhs.id
    }
    
    var coordinates: CLLocationCoordinate2D { coordinate }
    var image: String { AssetImage.Map.scooterMarker }
    var powerColor: Color { scooter.batteryColor }
}
