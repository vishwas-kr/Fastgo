//
//  Promo.swift
//  Fastgo
//
//  Created by vishwas on 1/10/26.
//
import SwiftUI
enum PromoVariant: Int, CaseIterable {
    case pass
    case bike
    case offer
    case parking
    
    var title : String {
        switch self {
        case .pass:
            return "Unlock your ride pass"
        case .bike:
            return "Rent a bike"
        case .offer:
            return "Get a discount"
        case .parking:
            return "Park your bike"
        }
    }
    
    var description : String {
        switch self {
        case .pass :
            return "Ride more, pay less!"
        case .bike :
            return "Rent nearby, ride free"
        case .offer:
            return "Deals you can’t miss"
        case .parking:
            return "Park with ease"
        }
    }
    
    var image : String {
        switch self {
        case .pass:
            AssetImage.Promo.pass
        case .bike:
            AssetImage.Promo.bike
        case .offer:
            AssetImage.Promo.offer
        case .parking:
            AssetImage.Promo.powerScooter
        }
    }
    
    var backgrounColor : Color {
        switch self {
        case .pass:
            return .teal.opacity(0.5)
        case .bike:
            return .pink.opacity(0.5)
        case .offer:
            return .green.opacity(0.5)
        case .parking:
            return .yellow.opacity(0.5)
        }
    }
}


struct PromoCode : Identifiable {
    let id = UUID()
    let image : String
    let title : String
    let description : String
    let expiry : String
}
