//
//  GeocodingService.swift
//  Fastgo
//
//  Created by vishwas on 2/7/26.
//

import Foundation
import CoreLocation

final class GeocodingService {
    static let shared = GeocodingService()
    
    private let geocoder = CLGeocoder()
    private var lastGeocodedLocation: CLLocation?
    private var cachedAddress: String?
    
    private init() {}
    
    func reverseGeocode(_ location: CLLocation) async -> String {
        if let last = lastGeocodedLocation,
           last.distance(from: location) < 50,
           let cached = cachedAddress {
            return cached
        }
        
        lastGeocodedLocation = location
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { return "Unknown Location" }
            
            let street = placemark.thoroughfare ?? ""
            let number = placemark.subThoroughfare ?? ""
            let city = placemark.locality ?? ""
            let state = placemark.administrativeArea ?? ""
            
            let address = "\(number) \(street), \(city) \(state)"
                .trimmingCharacters(in: .whitespaces)
            
            cachedAddress = address
            return address.isEmpty ? "Unknown Location" : address
        } catch {
            print("Geocoding Error: \(error)")
            return "Unknown Location"
        }
    }
}
