//
//  SignInViewModel.swift
//  Fastgo
//
//  Created by vishwas on 12/28/25.
//
import SwiftUI

class AuthViewModel : ObservableObject {
    private let router : Router
    
    init(router: Router) {
        self.router = router
    }
    
    @Published var phoneNumber : String = ""
    @Published var selectedCountry : Country = Country(name: "India", code: "IN", dialCode: "+91")
    
    private var fullPhoneNumber : String {
        selectedCountry.dialCode + phoneNumber
    }
    
    // MARK: Temp funcationality
    func buttonAction() {
        print("Selected Country: \(selectedCountry)")
        print("FULL Phone Number: \(fullPhoneNumber)")
        router.navigate(to: .verifyOTP)
    }
    
    
    func submitOTP(otp : String) {
        print("OTP submitted is : \(otp)")
        router.navigate(to: .basicInfo)
        router.navPath = NavigationPath()
    }
    
    func resendOTP() {
        print("Resend OTP tapped")
    }
}
