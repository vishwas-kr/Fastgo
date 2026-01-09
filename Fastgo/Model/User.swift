//
//  User.swift
//  Fastgo
//
//  Created by vishwas on 1/7/26.
//
import Foundation

struct UserStatus : Codable {
    let basicInfoCompleted: Bool
    
    private enum CodingKeys: String, CodingKey {
        case basicInfoCompleted = "basic_info_completed"
    }
}


struct UserBasicInfoUpdate: Codable {
    let name: String
    let gender: String
    let dateOfBirth: String
    let userStatus: UserStatus
    
    private enum CodingKeys: String, CodingKey {
        case name
        case gender
        case dateOfBirth = "date_of_birth"
        case userStatus = "user_status"
    }
}

struct BasicUser : Identifiable, Codable {
    let id: String
    let name: String?
    let phone: String
    let gender: String?
    let totalRides : Int
    let totalDistance : Double
    let profileImageUrl : String?
    let dateOfBirth : String?
    let userStatus: UserStatus
    
    private enum CodingKeys : String, CodingKey {
        case id
        case name
        case phone
        case gender
        case totalRides = "total_rides"
        case totalDistance = "total_distance"
        case profileImageUrl = "profile_image"
        case dateOfBirth = "date_of_birth"
        case userStatus = "user_status"
    }
    
    var dateOfBirthAsDate: Date? {
            guard let dateString = dateOfBirth else { return nil }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]
            return formatter.date(from: dateString)
        }
}
