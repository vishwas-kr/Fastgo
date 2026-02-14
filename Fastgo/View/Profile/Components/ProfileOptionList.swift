//
//  ProfileOptionList.swift
//  Fastgo
//
//  Created by vishwas on 1/11/26.
//

import SwiftUI
struct ProfileOptionList: View {
    @EnvironmentObject private var router : HomeRouter
    private let appShareURL = URL(string: "https://apps.apple.com/app/fastgo")!
    
    var body: some View {
        VStack(spacing: 0 ) {
            ForEach(ProfileOptions.allCases) { option in
                VStack(spacing:0){
                    if option == .inviteFriends {
                        ShareLink(
                            item: appShareURL,
                            preview: SharePreview(
                                "Ride with Fastgo!",
                                image: Image("logo")
                            )
                        ) {
                            optionRow(option: option)
                        }
                    } else {
                        NavigationLink(value: HomeRoutes.profileOptions(option.routes)){
                            optionRow(option: option)
                        }
                    }
                    Divider()
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
    }
    
    private func optionRow(option: ProfileOptions) -> some View {
        HStack (spacing: 16){
            Image(systemName: option.imageName)
                .resizable()
                .foregroundStyle(.black)
                .frame(width: 16, height: 16)
                .padding()
                .background(Circle().fill(Color(.systemGray6)))
            
            Text(option.title)
                .font(.subheadline)
                .foregroundStyle(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color(.systemGray2))
        }
        .contentShape(Rectangle())
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

