//
//  SignInViewModel.swift
//  Fastgo
//
//  Created by vishwas on 12/28/25.
//
import SwiftUI

class AuthViewModel : ObservableObject {
    private let appState = AppStateManager.shared
    private let supabaseService = SupabaseService.shared
    
    @Published var phoneNumber : String = ""
    @Published var selectedCountry : Country = Country(name: "India", code: "IN", dialCode: "+91")
    @Published var otp : String = ""
    
    @Published var canResendOTP: Bool = false
    @Published var resendCountdown: Int = 60
    
    private var resendTimer : Timer?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    var fullPhoneNumber : String {
        selectedCountry.dialCode + phoneNumber
    }
    
    private var isPhoneNumberValid : Bool {
        fullPhoneNumber.count >= 10 && phoneNumber.allSatisfy{$0.isNumber}
    }
    
    var isOTPValid : Bool {
        otp.count == 6 && otp.allSatisfy {$0.isNumber}
    }
    
    func sendOTP() async {
        guard isPhoneNumberValid else {
            showErrorMessage("Please enter a valid phone number")
            return
        }
        isLoading = true
        errorMessage = nil
        
        print("Selected Country: \(selectedCountry)")
        
        do {
            try await supabaseService.signInWithOtp(phoneNumber: fullPhoneNumber)
            print("OTP Sent Successfully to:: \(fullPhoneNumber)")
            startResendTimer()
        } catch {
            showErrorMessage("Failed to send OTP. Please try again.")
            print("Error Sending OTP:",error.localizedDescription)
        }
        isLoading = false
    }
    
    
    func verifyOTP() async {
        guard isOTPValid else {
            showErrorMessage("Please enter the complete OTP")
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            
            guard let session = try await supabaseService.verifyOTP(phoneNumber: fullPhoneNumber, otp: otp) else { return }
            
            await appState.setAuthenticated(userId:session.user.id.uuidString , phoneNumber: fullPhoneNumber)
            print("OTP verified successfully ✅")
            clearOTP()
        } catch {
            showErrorMessage("Invalid OTP. Please try again.")
            print("Error Verifying OTP:",error.localizedDescription)
        }
        isLoading = false
    }
    
    
    func signOut() async {
        do {
            try await supabaseService.signOut()
        } catch {
            print("Error Logging Out:",error.localizedDescription)
        }
    }
    
    func resendOTP() async {
        guard canResendOTP else { return }
        canResendOTP = false
        await sendOTP()
        print("Resend OTP tapped")
    }
    
    func clearData() {
        phoneNumber = ""
        otp = ""
        errorMessage = nil
        stopResendTimer()
    }
    
    func clearOTP() {
        otp = ""
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[weak self] in
            self?.showError = false
        }
        
    }
    
    private func startResendTimer() {
        resendCountdown = 60
        canResendOTP = false
        
        resendTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.resendCountdown > 0 {
                self.resendCountdown -= 1
            } else {
                self.canResendOTP = true
                timer.invalidate()
            }
        }
    }
    
     func stopResendTimer() {
        resendTimer?.invalidate()
        resendTimer = nil
        resendCountdown = 60
        canResendOTP = false
    }
    
    deinit {
        stopResendTimer()
    }
}


extension AuthViewModel {
    
    func validatePhoneNumber() -> Bool {
        switch selectedCountry.code {
        case "IN":
            return phoneNumber.count == 10
        default:
            return phoneNumber.count >= 10
        }
    }
}
