//
//  OPTVerifyView.swift
//  Fastgo
//
//  Created by vishwas on 12/28/25.
//

import SwiftUI
import Supabase

struct OTPVerifyView: View {
    @StateObject var viewModel: AuthViewModel
    @State private var otpDigits: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedIndex: Int?
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        VStack {
            VStack(spacing:8){
                Text("Enter 6-digit code")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                Text("We sent a verifiction code to your phone number \(viewModel.fullPhoneNumber)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                
            }
            .padding(.top,16)
            
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    OTPDigitField(
                        digit: $otpDigits[index],
                        isFocused: focusedIndex == index
                    )
                    .focused($focusedIndex, equals: index)
                    .onChange(of: otpDigits[index]) { _, newValue in
                        handleOTPChange(at: index, newValue: newValue)
                    }
                }
            }
            .padding(.horizontal)
            
            HStack{
                Text("You didn't received any code?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                
                if viewModel.canResendOTP {
                    Button("Resend"){
                        Task { await viewModel.resendOTP() }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                } else {
                    Text("Resend in \(viewModel.resendCountdown)s")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
            }
            .padding(.vertical)
            Button(action:{
                Task {
                    viewModel.otp = otpDigits.joined()
                    await viewModel.verifyOTP()
                }
                hideKeyboard()
                
            }){
                
                ZStack{
                    Text("Submit")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .opacity(viewModel.isLoading ? 0 : 1)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
                .frame(maxWidth:.infinity)
                .frame(height: 55)
                .background(viewModel.isOTPValid ? Color.green : Color.gray)
                .clipShape(Capsule())
            }
            .disabled(!viewModel.isOTPValid || viewModel.isLoading)
            .padding(.vertical,22)
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                CustomToolBarBackButton()
                
            }
        }
        .alert("Error", isPresented: $viewModel.showError ){
            Button("OK",role : .cancel){
                otpDigits = Array(repeating: "", count: 6 )
                focusedIndex = 0
            }
        } message : {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
        .onAppear{
            focusedIndex = 0
        }
    }
    
    private func handleOTPChange(at index: Int, newValue: String) {
        // Keep only last character if multiple entered
        if newValue.count > 1 {
            otpDigits[index] = String(newValue.last!)
        }
        
        // Auto-advance to next field
        if !newValue.isEmpty && index < 5 {
            focusedIndex = index + 1
        }
        
        // Auto-submit when complete
        if index == 5 && !newValue.isEmpty {
            focusedIndex = nil
            Task {
                viewModel.otp = otpDigits.joined()
                await viewModel.verifyOTP()
            }
        }
    }
}


struct OTPDigitField: View {
    @Binding var digit: String
    let isFocused: Bool
    
    var body: some View {
        TextField("", text: $digit)
            .font(.title)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .frame(maxWidth: 60, maxHeight: 60)
            .background(isFocused ? Color.green.opacity(0.02) : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        digit.isEmpty ? Color(.systemGray4) : Color.green,
                        lineWidth: isFocused ? 2 : 1
                    )
            )
    }
}
