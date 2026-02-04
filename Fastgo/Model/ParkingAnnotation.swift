//
//  ParkingAnnotation.swift
//  Fastgo
//
//  Created by vishwas on 2/2/26.
//

import Foundation
import CoreLocation

struct ParkingAnnotation: Identifiable, Equatable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let name: String
    
    static func == (lhs: ParkingAnnotation, rhs: ParkingAnnotation) -> Bool {
        lhs.id == rhs.id
    }
    
    var coordinates: CLLocationCoordinate2D { coordinate }
    var image: String { AssetImage.Map.scooterMarker }
}


struct Parking: Decodable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
}
