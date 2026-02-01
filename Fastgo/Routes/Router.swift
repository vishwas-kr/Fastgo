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

enum HomeRoutes : Hashable {
    case profile
    case profileOptions(ProfileOptionRoutes)
    case scanQRCode
    case rideNavigation(ScooterAnnotation?)
    case rideCompleted
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
