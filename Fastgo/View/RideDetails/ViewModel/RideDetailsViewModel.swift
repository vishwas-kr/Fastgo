//
//  RideDetailsViewModel.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

enum ScooterDetailFeature: String, CaseIterable {
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


enum ScooterDetailOptions : String, CaseIterable {
    case promo
    case payment
    
    var image : String {
        switch self {
        case .promo :
            return "promo"
        case .payment :
            return "pay"
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
