//
//  ProfileOptions.swift
//  Fastgo
//
//  Created by vishwas on 1/10/26.
//
import Foundation
enum ProfileOptions : Int, CaseIterable, Identifiable {
    var id : Int {return self.rawValue}
    
    case myAccount
    case paymentMethod
    case rideHistory
    case promoCode
    case inviteFriends
    
    var imageName : String {
        switch self {
        case .myAccount:
            return "person"
        case .paymentMethod:
            return "creditcard"
        case .rideHistory:
            return "doc.plaintext"
        case .promoCode:
            return "tag"
        case .inviteFriends:
            return "person.2"
        }
    }
    
    var title : String {
        switch self {
        case .myAccount:
            return "My Account"
        case .paymentMethod:
            return "Payment Mode"
        case .rideHistory:
            return "Ride History"
        case .promoCode:
            return "Promo Code"
        case .inviteFriends:
            return "Invite Friends"
        }
    }
    
    var routes : ProfileOptionRoutes {
        switch self {
        case .myAccount:
            return .myAccount
        case .paymentMethod:
            return .paymentMethod
        case .rideHistory:
            return .rideHistory
        case .promoCode:
            return .promoCode
        case .inviteFriends:
            return .inviteFriends
        }
    }
}
