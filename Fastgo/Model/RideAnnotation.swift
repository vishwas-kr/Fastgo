//
//  RideAnnotation.swift
//  Fastgo
//
//  Created by vishwas on 1/17/26.
//
import SwiftUI
import MapKit

struct RideAnnotation : Identifiable {
    let id = UUID()
    let title : String
    let coordinates : CLLocationCoordinate2D
    let type : RideType
    
    enum RideType {
        case electric
        case electricHevy
        case electricLight
        
        
        var image : String {
            switch self {
            case .electric, .electricHevy, .electricLight :
                return "marker"
            }
        }
        
        var powerColor : Color {
            switch self {
            case .electric:
                return .green
            case .electricLight:
                return .yellow
            case . electricHevy:
                return .orange
            }
        }
    }
    
}
