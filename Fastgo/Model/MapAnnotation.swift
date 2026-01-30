//
//  RideAnnotation.swift
//  Fastgo
//
//  Created by vishwas on 1/17/26.
//
import SwiftUI
import MapKit

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
