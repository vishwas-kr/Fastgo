//
//  Route.swift
//  Fastgo
//
//  Created by vishwas on 1/2/26.
//

import SwiftUI
final class Router : ObservableObject {
    
    @Published var navPath = NavigationPath()
    
    enum AuthFlow : Hashable, Codable {
        case onboarding
        case signIn
        case verifyOTP
        case newOnboardingSuccess
        case basicInfo
        case home
    }
    
    func navigate(to destination: AuthFlow ) {
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
