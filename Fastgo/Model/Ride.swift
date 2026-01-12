//
//  Ride.swift
//  Fastgo
//
//  Created by vishwas on 1/12/26.
//
import Foundation

enum RideStatus {
    case completed
    case cancelled
    case upcoming
    case all
}

struct RideStatusModel : Identifiable {
    let id = UUID()
    let location : String
    let date : String
    let fare : Double
    let status : RideStatus
}


