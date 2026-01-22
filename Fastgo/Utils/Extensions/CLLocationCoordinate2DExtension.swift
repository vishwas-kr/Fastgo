//
//  CLLocationCoordinate2DEctension.swift
//  Fastgo
//
//  Created by vishwas on 1/17/26.
//

import MapKit

extension CLLocationCoordinate2D {
    func distance(to coordinate : CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let to = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return from.distance(from: to)
    }
}
