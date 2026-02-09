//
//  Route.swift
//  Fastgo
//
//  Created by vishwas on 1/2/26.
//

import SwiftUI

enum ProfileOptionRoutes : Hashable {
    case myAccount
    case paymentMethod
    case rideHistory
    case promoCode
    case inviteFriends
}

enum QRScanSource: Hashable {
    case home
    case rideNavigation
}

enum HomeRoutes : Hashable {
    case profile
    case profileOptions(ProfileOptionRoutes)
    case scanQRCode(QRScanSource)
    case rideNavigation(ScooterAnnotation?)
    case rideCompleted
    case ridePhoto
}

final class HomeRouter : ObservableObject {
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: HomeRoutes ) {
        navPath.append(destination)
        print("ADDED PATH: \(navPath)")
    }
    
    func navigatePop(){
        navPath.removeLast()
        print("POPED PATH: \(navPath)")
    }
    
    func navigateToHome(){
        navPath.removeLast(navPath.count)
        print("HOME PATH Triggered: \(navPath)")
    }
    
}
