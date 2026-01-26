//
//  AuthManager.swift
//  Fastgo
//
//  Created by vishwas on 1/5/26.
//

import Foundation
import Supabase

@MainActor
class AppStateManager : ObservableObject {
    
    static let shared = AppStateManager()
    
    private let supabaseService = SupabaseService.shared
    
    @Published private(set) var currentFlow : AppFlow = .loading
    @Published private(set) var hasSeenOnboarding : Bool = false
    @Published private(set) var isAuthenticated : Bool = false
    @Published private(set) var hasCompletedProfile : Bool = false
    
    @Published var userPhoneNumber : String?
    @Published var userID : String?
    
    @Published var currentUser : UserProfile?
    
    
    private init() {
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasOnboardingSeen")
    }
    
    
    func initializeApp() async {
        print("Initializing App State 🚀")
        await checkExistingSession()
        updateFlow()
        
        checkAppStatus()
    }
    
    func completeOnboarding() {
        hasSeenOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasOnboardingSeen")
        updateFlow()
        print("Onboarding completed: \(hasSeenOnboarding) ✅")
    }
    
    func setAuthenticated(userId: String, phoneNumber: String) async {
        self.isAuthenticated = true
        self.userID = userId
        self.userPhoneNumber = phoneNumber
        
        await fetchOrCreateUser(userId:userId,phoneNumber:phoneNumber)
        
        updateFlow()
        print("User AUthenticated ✅")
    }
    
    func completeBasicInfo() {
        hasCompletedProfile = true
        updateFlow()
        print("Baisc Info is Completed ✅")
    }
    
    func signOut() async {
        do {
            try await supabaseService.signOut()
            isAuthenticated = false
            userID = nil
            userPhoneNumber = nil
            currentUser = nil
            
            CacheManager.shared.removeAll()
            updateFlow()
            print("User signed out")
            
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func resetApp() async {
        hasSeenOnboarding = false
        isAuthenticated = false
        hasCompletedProfile = false
        userID = nil
        userPhoneNumber = nil
        try? await supabaseService.signOut()
        UserDefaults.standard.removeObject(forKey: "hasOnboardingSeen")
        // UserDefaults.standard.removeObject(forKey: hasCompletedProfileKey)
        
        updateFlow()
        print("🔄 App reset to initial state")
    }
    
    func checkExistingSession() async {
        do {
            let session = try await supabaseService.getCurrentSession()
            
            if let session = session {
                isAuthenticated = true
                userID = session.user.id.uuidString
                userPhoneNumber = session.user.phone
                await fetchUserData(userID: session.user.id.uuidString)
                print("Found existing session for user: \(userID ?? "unknown")")
            } else {
                isAuthenticated = false
                print("No existing session found ℹ️")
            }
        } catch {
            isAuthenticated = false
            print("Error checking session: \(error.localizedDescription)")
        }
    }
    
    func updateFlow(){
        let previousFlow = currentFlow
        
        if !hasSeenOnboarding {
            currentFlow = .onboarding
        } else if !isAuthenticated {
            currentFlow = .signIn
        } else if !hasCompletedProfile {
            currentFlow = .basicInfo
        } else {
            currentFlow = .home
        }
        
        if previousFlow != currentFlow {
            print("🔀 Flow changed: \(previousFlow) → \(currentFlow)")
        }
    }
    func checkAppStatus() {
        print("""
                
                📊 Current App State:
                ├─ Has Seen Onboarding: \(hasSeenOnboarding)
                ├─ Is Authenticated: \(isAuthenticated)
                ├─ Has Completed Profile: \(hasCompletedProfile)
                ├─ User ID: \(userID ?? "nil")
                ├─ Phone Number: \(userPhoneNumber ?? "nil")
                └─ Current Flow: \(currentFlow)
                
                """)
    }
    
    private func fetchOrCreateUser(userId: String, phoneNumber: String) async {
        do {
            if let user = try await UserService.shared.getUser(userId: userId) {
                currentUser = user
                hasCompletedProfile = user.userStatus.basicInfoCompleted
                print("Existing user. Profile Completed: \(hasCompletedProfile)")
            } else {
                print("fetchOrCreateUser")
                let newUser = try await UserService.shared.createUser(userId: userId, phoneNumber: phoneNumber)
                
                currentUser = newUser
                hasCompletedProfile = false
                print("New user created in DB")
            }
            
        } catch {
            print("Error in fetchOrCreateUser: \(error)")
            hasCompletedProfile = false
        }
    }
    
    private func fetchUserData(userID: String) async {
        do {
            let user = try await UserService.shared.getUser(userId: userID)
            if let user = user {
                currentUser = user
                hasCompletedProfile = user.userStatus.basicInfoCompleted
                print("User data fetched. Basic info complete: \(hasCompletedProfile)")
            } else {
                hasCompletedProfile = false
                print("User not found in database")
            }
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
            hasCompletedProfile = false
        }
    }
}


enum AppFlow : Equatable {
    case loading
    case onboarding
    case signIn
    case verifyOTP
    case basicInfo
    case home
    
    var description: String {
        switch self {
        case .loading: return "Loading"
        case .onboarding: return "Onboarding"
        case .signIn: return "Sign In"
        case .verifyOTP: return "Verify OTP"
        case .basicInfo: return "Basic Info"
        case .home: return "Home"
        }
    }
}
