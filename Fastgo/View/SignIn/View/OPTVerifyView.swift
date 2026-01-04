//
//  OPTVerifyView.swift
//  Fastgo
//
//  Created by vishwas on 12/28/25.
//

import SwiftUI

struct OPTVerifyView: View {
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedIndex : Int?
    @EnvironmentObject private var router : Router
    var body: some View {
        VStack {
            VStack(spacing:8){
                Text("Enter 6-digit code")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                Text("We sent a verifiction code to your phone number +91 8210012345")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                
            }
            .padding(.top,16)
            HStack{
                ForEach(0 ... 5, id:\.self){ index in
                    TextField("",text:$otp[index])
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: 60, maxHeight: 60)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .focused($focusedIndex, equals: index)
                        .background(.green.opacity(focusedIndex == index ? 0.02 :0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(focusedIndex == index ? Color.green : Color(.systemGray4), lineWidth: 1)
                                .stroke(otp[index].isEmpty ? Color(.systemGray4) : Color.green, lineWidth:1)
                        )
                        .onChange(of: otp[index]) {_, newValue in
                            if newValue.count > 1 {
                                otp[index] = String(newValue.last!)
                            }
                            
                            if !newValue.isEmpty {
                                focusedIndex = index < 5 ? index + 1 : nil
                            }
                        }
                }
            }.padding(.vertical,24)
            HStack{
                Text("You didn't received any code?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                Button(action:{}){
                    Text("Resent code")
                        .fontWeight(.semibold)
                }
            }
            .padding(.vertical)
            Button(action:{
                hideKeyboard()
                let otpCode = otp.joined()
                print("OTP:", otpCode)
                router.navigate(to: .basicInfo)
            }){
                Text("Submit")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height:55)
                    .background(.green)
                    .clipShape(Capsule())
            }
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
    }
}

#Preview {
    OPTVerifyView()
}



// has fixed height and made for the bottom view with Image Background. Not used.


//struct OPTVerifyView1: View {
//    @State private var otp: [String] = Array(repeating: "", count: 6)
//    @FocusState private var focusedIndex : Int?
//    var body: some View {
//        VStack {
//            VStack(spacing:8){
//                Text("Verify your phone\nnumber")
//                    .font(.title)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.black)
//                    .multilineTextAlignment(.center)
//                Text("We sent a 6 digit code to +91 8210012345")
//                    .font(.subheadline)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.gray)
//
//            }
//            Spacer()
//            HStack{
//                ForEach(0 ... 5, id:\.self){ index in
//                    TextField("",text:$otp[index])
//                        .font(.title)
//                        .fontWeight(.semibold)
//                        .padding()
//                        .frame(maxWidth: 60, maxHeight: 60)
//                        .keyboardType(.numberPad)
//                        .multilineTextAlignment(.center)
//                        .focused($focusedIndex, equals: index)
//                        .background(.green.opacity(focusedIndex == index ? 0.02 :0))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(focusedIndex == index ? Color.green : Color(.systemGray4), lineWidth: 1)
//                                .stroke(otp[index].isEmpty ? Color(.systemGray4) : Color.green, lineWidth:1)
//                        )
//                        .onChange(of: otp[index]) {_, newValue in
//                            if newValue.count > 1 {
//                                otp[index] = String(newValue.last!)
//                            }
//
//                            if !newValue.isEmpty {
//                                focusedIndex = index < 5 ? index + 1 : nil
//                            }
//                        }
//                }
//            }.padding()
//            Spacer()
//            Button(action:{
//                hideKeyboard()
//                let otpCode = otp.joined()
//                print("OTP:", otpCode)
//            }){
//                Text("Submit")
//                    .font(.subheadline)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .frame(height:55)
//                    .background(.green)
//                    .clipShape(Capsule())
//            }
//        }
//        .padding()
//        .frame(maxHeight: UIScreen.main.bounds.height * 0.35)
//        .background(.white)
//        .clipShape(RoundedCorners(radius: 40, corners: [.topLeft, .topRight]))
//    }
//}
