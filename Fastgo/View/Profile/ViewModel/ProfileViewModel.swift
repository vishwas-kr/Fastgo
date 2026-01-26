//
//  ProfileViewModel.swift
//  Fastgo
//
//  Created by vishwas on 1/25/26.
//
import Foundation

@MainActor
class ProfileViewModel : ObservableObject{
    
    @Published var currentUser : UserProfile?
    
    init(){
        getCurrentUser()
    }
    
    func getCurrentUser(){
        currentUser = AppStateManager.shared.currentUser
    }
    
    func refreshUserProfile() async {
        do {
            let session = try await SupabaseService.shared.getCurrentSession()
            
            if let session = session {
                currentUser = try await UserService.shared.getUser(userId: session.user.id.uuidString)
            }
        } catch {
            print("Error Refreshing User \(error)")
        }
    }
}
