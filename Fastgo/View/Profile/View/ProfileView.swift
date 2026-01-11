//
//  ProfileView.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        CustomBackgroundView(imageName: "obo1", imageHeightRatio: 0.35){
            VStack{
                ScrollView(showsIndicators: false) {
                    ProfileCard()
                    ProfileOptionList()
                }
                .padding(.vertical)
                
                CustomGreenButton(action: {
                    Task{ await AppStateManager.shared.signOut()}
                }, title: "Logout")
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemGray6))
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                CustomToolBarBackButton()
            }
        }
    }
}

#Preview {
    ProfileView()
}





