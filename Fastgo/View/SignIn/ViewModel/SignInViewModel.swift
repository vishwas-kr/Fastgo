//
//  SignInViewModel.swift
//  Fastgo
//
//  Created by vishwas on 12/28/25.
//
import Combine

enum LoginStep {
    case phoneNumber
    case otp
}


class SignInViewModel : ObservableObject {
    @Published var siginInStep : LoginStep = .phoneNumber
    
    static let shared = SignInViewModel()
    
    private init() {}
}
