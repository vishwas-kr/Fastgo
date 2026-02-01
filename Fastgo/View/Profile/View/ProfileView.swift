//
//  ProfileView.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    var body: some View {
        CustomBackgroundView(imageName: AssetImage.Profile.profileBackground, imageHeightRatio: 0.35) {
            VStack {
                ScrollView(showsIndicators: false) {
                    ProfileCard(userData: $viewModel.currentUser)
                        .padding(.bottom)
                    ProfileOptionList()
                }
                .padding(.vertical)
                
                CustomGreenButton(action: {
                    Task { await AppStateManager.shared.signOut() }
                }, title: "Logout",imageName: nil)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemGray6))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomToolBarBackButton()
            }
        }
        .onAppear {
            viewModel.getCurrentUser()
        }
    }
}

#Preview {
    ProfileView()
}
