//
//  SupabaseService.swift
//  Fastgo
//
//  Created by vishwas on 1/5/26.
//

import Supabase
import Foundation

struct SupabaseService {
    static let shared = SupabaseService()
    private let client : SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: APIConstants.project_URL)!,
            supabaseKey: APIConstants.projectAPI_KEY
        )
        print("SupabaseService initialized ✅")
    }
    
    var currentUser : User? {
        get async { try? await client.auth.session.user }
    }
    
    func signInWithOtp (phoneNumber: String) async throws {
        
        try await client.auth.signInWithOTP(phone: phoneNumber)
    }
    
    func verifyOTP (phoneNumber:String, otp: String) async throws -> Session? {
        
        let result = try await client.auth.verifyOTP(phone: phoneNumber, token: otp, type: .sms)
        return result.session
        
    }
    
    func getCurrentSession() async throws -> Session? {
        do {
            let session = try await client.auth.session
            return session
        } catch {
            return nil
        }
    }
    
    func refreshSession() async throws -> Session {
        let session = try await client.auth.session
        return session
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
}


extension SupabaseService {
    enum AuthError : LocalizedError {
        case invalidPhoneNumber
        case invalidOTP
        case sessionExpired
        case networkError
        case unknown(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidPhoneNumber:
                return "Please enter a valid phone number"
            case .invalidOTP:
                return "Invalid OTP. Please try again"
            case .sessionExpired:
                return "Your session has expired. Please sign in again"
            case .networkError:
                return "Network Error. Please check your connection"
            case .unknown(let error):
                return "An error occurred: \(error.localizedDescription)"
            }
        }
    }
    
    func handleError(_ error: Error) -> AuthError {
        if error.localizedDescription.contains("network") {
            return .networkError
        } else if error.localizedDescription.contains("session") {
            return .sessionExpired
        } else {
            return .unknown(error)
        }
    }
}
