//
//  RideDetailsViewModel.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

enum ScooterRideActions: String, CaseIterable {
    case ring = "Ring"
    case navigate = "Navigate"
    case reportIssue = "Report Issue"
    
    var image : String {
        switch self {
        case .ring :
            return "bell"
        case .navigate:
            return "location"
        case .reportIssue:
            return "exclamationmark.triangle"
        }
    }
}


enum ScooterRideMenu : String, CaseIterable {
    case promo
    case payment
    
    var image : String {
        switch self {
        case .promo :
            return AssetImage.Profile.promoCode
        case .payment :
            return AssetImage.Profile.paymentMethod
        }
    }
    
    var title : String {
        switch self {
        case .promo :
            return "Promo Code"
        case .payment:
            return "Payment Method"
        }
    }
}
