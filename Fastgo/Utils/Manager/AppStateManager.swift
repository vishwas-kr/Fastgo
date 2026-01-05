//
//  AuthManager.swift
//  Fastgo
//
//  Created by vishwas on 1/5/26.
//

import Foundation

class AppStateManager : ObservableObject {
    
    static let shared = AppStateManager()
    
    private init() {}
    
    @Published var isLoggedIn: Bool = false
    @Published var isProfileComplete: Bool = false
    
    var hasSeenOnboarding : Bool {
        UserDefaults.standard.bool(forKey: "hasOnboardingSeen")
    }
    
    
    func setOnboadringSeen() {
        UserDefaults.standard.set(true, forKey: "hasOnboardingSeen")
        print("ONBORADING Status: \(hasSeenOnboarding)")
    }
    
    func checkAppStatus() {
        print("ONBOARDING Status : \(hasSeenOnboarding)")
        print("USERLOGGED Status : \(isLoggedIn)")
        print("PROFILE Status: \(isProfileComplete)")
    }
}
