//
//  SignInView.swift
//  Fastgo
//
//  Created by vishwas on 12/26/25.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var keyboard = KeyboardHeightHelper()
    @StateObject private var viewModel : AuthViewModel
    
    init(router: Router) {
        _viewModel = .init(
            wrappedValue: AuthViewModel(router: router)
        )
    }
    
    var body: some View {
        ZStack{
            VStack {
                Image("login")
                    .resizable()
                    .frame(width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height * 0.65)
                    .ignoresSafeArea()
                
                Spacer()
            }
            VStack{
                Spacer()
                PhoneNumberView(viewModel: viewModel)
            }
            .offset(y: -keyboard.keyboardHeight * 0.15)
            .animation(.easeOut(duration: 0.3), value: keyboard.keyboardHeight)
            
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    AuthView(router: Router())
}



//MARK: Old Implementation

//            VStack(){
//                Spacer()
//                RoundedRectangle(cornerRadius: 40)
//                    .frame(maxHeight: UIScreen.main.bounds.height * 0.35)
//                    .foregroundStyle(.white)
//                    .overlay(
//                        VStack {
//                            VStack(spacing:8){
//                                Text("Enter your mobile \n number")
//                                    .font(.title)
//                                    .fontWeight(.semibold)
//                                    .multilineTextAlignment(.center)
//                                Text("We will send you a confirmation code")
//                                    .font(.subheadline)
//                                    .fontWeight(.light)
//                                    .foregroundStyle(.gray)
//
//                            }
//                            Spacer()
//                            HStack{
//                                CountryPicker()
//                                TextField("Enter phone number",text: $text)
//                                    .focused($isFocused)
//                                    .font(.subheadline)
//                                    .fontWeight(.medium)
//                                    .keyboardType(.numberPad)
//                            }
//                            .background(.green.opacity(isFocused ? 0.02 :0))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(isFocused ? Color.green : Color(.systemGray6), lineWidth: 1)
//                            )
//                                Spacer()
//                                Button(action:{
//                                    hideKeyboard()
//                                }){
//                                    Text("Continue")
//                                        .font(.subheadline)
//                                        .fontWeight(.semibold)
//                                        .foregroundStyle(.white)
//                                        .padding()
//                                        .frame(maxWidth: .infinity)
//                                        .frame(height:55)
//                                        .background(.green)
//                                        .clipShape(Capsule())
//                                        .onChange(of: text) {_, newValue in
//                                            let filtered = newValue.filter { $0.isNumber }
//                                            text = String(filtered.prefix(10))
//                                        }
//                                }
//                            }.padding()
//                    )
//                    .offset(y: -keyboard.keyboardHeight * 0.2)
//                    .animation(.easeOut(duration: 0.3), value: keyboard.keyboardHeight)
//            }

//MARK: Async Image for
//                AsyncImage(
//                    url: URL(string: AppImageConstants.image1)
//                ) { image in
//                    image
//                        .resizable()
//                        .frame(width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height * 0.65)
//                        .ignoresSafeArea()
//
//                } placeholder: {
//                    ProgressView()
//                        .frame(width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height * 0.6)
//                        .ignoresSafeArea(edges : .top)
//                }
//                Spacer()
