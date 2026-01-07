//
//  OnboardingPA.swift
//  Fastgo
//
//  Created by vishwas on 1/5/26.
//
enum OnboardingPage : Int, CaseIterable {
    case firstPage
    case secondPage
    case thirdPage
    
    var title : String{
        switch self {
        case .firstPage : return "Beat the traffic"
        case .secondPage : return "Quick rides big vibes."
        case .thirdPage : return "Just pure movement"
        }
    }
    
    var description : String {
        switch self {
        case .firstPage:
            return "One tap is all it takes to turn any street into a shortcut."
        case .secondPage:
            return "Your city never slows down, and neither should you."
        case .thirdPage:
            return "Less fuel, less noise, more freedom in every mile."
        }
    }
}

