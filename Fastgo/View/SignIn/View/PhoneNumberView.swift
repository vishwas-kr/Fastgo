//
//  PhoneNumberView.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI
struct PhoneNumberView : View {
    @FocusState private var isFocused : Bool
    @State private var showOTPView : Bool = false
    @StateObject var viewModel : AuthViewModel
    var body: some View {
        VStack {
            VStack(spacing:8){
                Text("Enter your mobile \n number")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                Text("We will send you a confirmation code")
                    .font(.subheadline)
                
                    .foregroundStyle(.gray)
                
            }
            Spacer()
            HStack{
                CountryPicker(selectedCountry: $viewModel.selectedCountry)
                TextField("Enter phone number",text: $viewModel.phoneNumber)
                    .focused($isFocused)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                    .keyboardType(.numberPad)
            }
            .background(.green.opacity(isFocused ? 0.02 :0))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.green : Color(.systemGray6), lineWidth: 1)
            )
            Spacer()
            Button(action:{
                isFocused = false
                Task {
                    await viewModel.sendOTP()
                    if viewModel.errorMessage == nil {
                        showOTPView = true
                    }
                }
            }){
                Text("Continue")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height:55)
                    .background(.green)
                    .clipShape(Capsule())
            }
            .onChange(of: viewModel.phoneNumber) {_, newValue in
                let filtered = newValue.filter { $0.isNumber }
                viewModel.phoneNumber = String(filtered.prefix(10))
            }
        }
        .padding()
        .frame(maxHeight: UIScreen.main.bounds.height * 0.35)
        .background(.white)
        .clipShape(RoundedCorners(radius: 40, corners: [.topLeft, .topRight]))
        .navigationDestination(isPresented: $showOTPView){
            OTPVerifyView(viewModel: viewModel)
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}
