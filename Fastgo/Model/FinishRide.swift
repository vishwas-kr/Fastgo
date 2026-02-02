//
//  FinishRide.swift
//  Fastgo
//
//  Created by vishwas on 2/2/26.
//
import Foundation

enum FinishRideData : CaseIterable {
    case parking
    case noParking
    case slowZone
    
    var title : String {
        switch self {
        case .parking:
            return "Preferred parking spots"
        case .noParking:
            return "No Parking Zones"
        case .slowZone:
            return "Slow zones"
        }
    }
    
    var desc : String {
        switch self {
        case .parking :
            return "Parking spots with enhanced parking infrastructure."
        case .noParking:
            return "Your vehicle will operate, but you can't end your ride in red zone."
        case .slowZone:
            return "Your vehicle will slow down in these zones."
        }
    }
    
    var image : String {
        switch self {
        case .parking:
            return "n6"
        case .noParking:
            return "n6"
        case .slowZone:
            return "n6"
        }
    }
}

