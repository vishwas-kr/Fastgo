//
//  BasicInfo.swift
//  Fastgo
//
//  Created by vishwas on 1/7/26.
//

enum Gender : String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case none
}


enum BasicInfo: Int, CaseIterable {
    case name
    case dob
    case gender
    
    var title: String {
        switch self {
        case .name : return  "What is your name?"
        case .dob : return "What is your date of birth?"
        case .gender : return "What is your gender?"
        }
    }
    
    var description : String {
        switch self {
        case .name:
            return "We need a little more info before you can use this app"
        case .dob:
            return "We need a little more info before you can use this app"
        case .gender:
            return "We need a little more info before you can use this app"
        }
    }
}
