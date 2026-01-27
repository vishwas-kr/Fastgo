//
//  SignInView.swift
//  Fastgo
//
//  Created by vishwas on 12/26/25.
//

import SwiftUI
import Supabase

struct AuthFlowView: View {
    @StateObject private var keyboard = KeyboardHeightHelper()
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    Image(AssetImage.Auth.background)
                        .resizable()
                        .scaledToFill()
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
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}


#Preview{
    AuthFlowView()
}
