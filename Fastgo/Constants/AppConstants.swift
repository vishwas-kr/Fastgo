//
//  AppConstants.swift
//  Fastgo
//
//  Created by vishwas on 12/25/25.
//

import Foundation

struct AppImageConstants {
    static let image1 = "https://plus.unsplash.com/premium_vector-1747611674632-34d5ff502ee2?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTh8fGJpa2V8ZW58MHwxfDB8fHww"
    static let image2 = "https://plus.unsplash.com/premium_vector-1736409565156-0ba411fd1a0a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fGJpa2V8ZW58MHwxfDB8fHww"
    
    static let image3 = "https://plus.unsplash.com/premium_vector-1724366105461-06925f20d872?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGJpa2V8ZW58MHwxfDB8fHww"
    
    static let image4 = "https://plus.unsplash.com/premium_vector-1747668808416-ca3680f0f148?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjJ8fGJpa2V8ZW58MHwxfDB8fHww"
    
    static let image5 = "https://plus.unsplash.com/premium_vector-1765373833220-e9019ed64e71?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDl8fGJpa2V8ZW58MHwxfDB8fHww"
    
    static let image6 = "https://plus.unsplash.com/premium_vector-1737556376200-dc0eae520e5c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzJ8fGJpa2V8ZW58MHwxfDB8fHww"
    

    
    

    
    static let scooter3 = "https://plus.unsplash.com/premium_vector-1748084731480-1f48480a5ca5?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHNjb290ZXJ8ZW58MHwxfDB8fHww"
    
    
    static let rideHistory = "https://images.unsplash.com/vector-1754146318493-21c86aea0a24?q=80&w=2148&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    
    
    static let ride = "https://plus.unsplash.com/premium_vector-1746864652491-42ffda7b801c?q=80&w=2148&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    
    static let park2 = "https://plus.unsplash.com/premium_vector-1747662236177-966f085effeb?q=80&w=2242&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    
    
    static let scan = "https://plus.unsplash.com/premium_vector-1746119139844-43296749b6e2?q=80&w=2148&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    
    static let riders = "https://plus.unsplash.com/premium_vector-1746864652737-4e659555b1e7?q=80&w=2148&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    
    static let nav = "https://plus.unsplash.com/premium_vector-1746864652496-bef1fc3485e3?q=80&w=2148&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
}

enum AssetImage {
    enum Onboarding {
        static let ride = "onb"
        static let pay = "onb1"
        static let map = "onb2"
        static let offer = "onb3"
        static let ai = "onb4"
    }

    enum Auth {
        static let background = "onb3"
    }
    
    enum Profile{
        static let profileBackground = "profileBackground"
        static let kilometer = "kilometer"
        static let rides = "totalRides"
        static let rideHistoryBackground = "rideHistoryBackground"
        static let avatarBoy = "boy"
        static let avatarGirl = "girl"
        static let promoCode = "promo"
        static let rideHistoryDistanceIcon = "distance"
        static let paymentMethod = "pay"
    }
    
    enum Promo {
        static let pass = "pass"
        static let bike = "scooter"
        static let offer = "offer"
        static let powerScooter = "powerScooter"
    }
    
    enum Map{
        static let scooterMarker = "marker"
        static let parkingMarker = "parking"
        static let user = "boy"
    }
    
    enum Scooter {
        static let scooter = "scooter"
    }
    
    enum FinishRide {
        static let background = "finishRideBackground"
        static let slowDown = "slowZone"
        static let noParking = "noParking"
        static let parking = "parking"
    }
}
