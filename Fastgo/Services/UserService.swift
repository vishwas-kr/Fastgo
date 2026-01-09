//
//  UserService.swift
//  Fastgo
//
//  Created by vishwas on 1/7/26.
//

import Supabase
import Foundation

class UserService {
    static let shared = UserService()
    private let client : SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: APIConstants.project_URL)!,
            supabaseKey: APIConstants.projectAPI_KEY
        )
        print("Supabase UserService initialized ✅")
    }
    
    
    func createUser(userId: String, phoneNumber: String) async throws -> BasicUser {
        let basicUser = BasicUser(
            id: userId,
            name: nil,
            phone: phoneNumber,
            gender: nil,
            totalRides: 0,
            totalDistance: 0.0,
            profileImageUrl: "",
            dateOfBirth: nil,
            userStatus: UserStatus(basicInfoCompleted: false)
        )
        
        let response : [BasicUser] = try await client.from("users").insert(basicUser).select().execute().value
        guard let user = response.first else {
            throw UserServiceError.userCreationFailed
        }
        
        print("New user created: \(userId)")
        return user
        
    }
    
    func getUser(userId: String) async throws -> BasicUser? {
        do {
            let response : [BasicUser] = try await client.from("users").select().eq("id", value: userId).execute().value
            
            print("User Fetched: \(response)")
            return response.first
        } catch {
            if error.localizedDescription.contains("no rows") {
                print("ℹ️ User not found with ID: \(userId)")
                return nil
            }
            throw error
        }
    }
    
    
    func updateBasicInfo(userId: String, name: String, dateOfBirth: String, gender: String) async throws -> BasicUser {
        let update = UserBasicInfoUpdate(
            name: name,
            gender: gender,
            dateOfBirth: dateOfBirth,
            userStatus: UserStatus(basicInfoCompleted: true)
        )
        
        let response: [BasicUser] = try await client
            .from("users")
            .update(update)
            .eq("id", value: userId)
            .select()  // ← Also needed here!
            .execute()
            .value
        
        guard let user = response.first else {
            throw UserServiceError.updateFailed
        }
        
        print("Basic info updated for: \(name)")
        return user
    }
    
    func isBasicInfoCompleted(userId: String) async throws -> Bool{
        if let user = try await getUser(userId: userId) {
            return user.userStatus.basicInfoCompleted
        }
        
        return false
    }
    
    
    func updateProfileImage(userId:String, imageUrl: String) async throws {
        let update = ["profile_image": imageUrl]
        
        try await client.from("users").update(update).eq("id", value: userId).execute()
        
        print("Profile pic updated")
    }
}


extension UserService {
    enum UserServiceError: LocalizedError {
        case userNotFound
        case userCreationFailed
        case updateFailed
        case invalidData
        case networkError
        
        var errorDescription: String? {
            switch self {
            case .userNotFound:
                return "User not found"
            case .userCreationFailed:
                return "Failed to create user"
            case .updateFailed:
                return "Failed to update user"
            case .invalidData:
                return "Invalid user data"
            case .networkError:
                return "Network error occurred"
            }
        }
    }
}
