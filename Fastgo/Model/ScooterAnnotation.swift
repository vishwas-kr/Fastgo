//
//  RideAnnotation.swift
//  Fastgo
//
//  Created by vishwas on 1/17/26.
//
import SwiftUI
import MapKit

struct ScooterAnnotation: Identifiable, Equatable, Hashable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let scooter: Scooter
    static func == (lhs: ScooterAnnotation, rhs: ScooterAnnotation) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var coordinates: CLLocationCoordinate2D { coordinate }
    var image: String { AssetImage.Map.scooterMarker }
    var powerColor: Color { scooter.batteryColor }
    
    static let preview = ScooterAnnotation(
        id: "preview-1",
        coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        scooter: Scooter(
            id: "preview-1",
            uniqueCode: "SC001",
            type: .sports,
            battery: 85,
            rangeKm: 25,
            perMinCost: 0.25,
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            status: .available
        )
    )
}

