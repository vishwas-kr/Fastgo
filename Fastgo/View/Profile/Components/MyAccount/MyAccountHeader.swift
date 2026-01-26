//
//  MyAccountHeader.swift
//  Fastgo
//
//  Created by vishwas on 1/26/26.
//
import SwiftUI

struct MyAccountHeader : View{
    @StateObject var viewModel : MyAccountViewModel
    @Binding var isShowingPhotoPicker : Bool
    var body : some View {
        HStack(spacing: 12){
            MyAccountAvatar(cachedImage: viewModel.profileImage, imageUrl: viewModel.profileImageUrl, gender: viewModel.draft.gender)
            VStack(alignment:.leading) {
                Text(viewModel.draft.name)
                    .font(.title3)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text("User id: Dani@487")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .frame(width: UIScreen.main.bounds.width / 3, alignment: .leading)
            Spacer()
            Button(action: {
                isShowingPhotoPicker = true
            }){
                Text("Change Photo")
                    .font(.footnote)
                
                
            }
            .padding(12)
            .foregroundStyle(.green)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.green)
            )
        }
        .padding(.vertical,24)
        .onAppear{
            Task{
                viewModel.checkCachedProfileImage()
            }
        }
    }
    
}
