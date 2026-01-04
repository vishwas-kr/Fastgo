//
//  PhoneNumberView.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI
struct PhoneNumberView : View {
    @State private var text = ""
    @FocusState private var isFocused : Bool
    @StateObject private var viewModel = SignInViewModel.shared
    @State private var navigateOtp : Bool = false
    @EnvironmentObject private var router : Router
    var body: some View {
        // NavigationStack {
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
                CountryPicker()
                TextField("Enter phone number",text: $text)
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
                hideKeyboard()
                // viewModel.siginInStep = .otp
                //navigateOtp.toggle()
                router.navigate(to: .verifyOTP)
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
                    .onChange(of: text) {_, newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        text = String(filtered.prefix(10))
                    }
            }
        }
        .padding()
        .frame(maxHeight: UIScreen.main.bounds.height * 0.35)
        .background(.white)
        .clipShape(RoundedCorners(radius: 40, corners: [.topLeft, .topRight]))
        //        .navigationDestination(isPresented: $navigateOtp){
        //            OPTVerifyView1()
        //        }
        //  }
    }
}
