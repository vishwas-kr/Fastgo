//
//  ProfileOptionList.swift
//  Fastgo
//
//  Created by vishwas on 1/11/26.
//

import SwiftUI
struct ProfileOptionList: View {
    @EnvironmentObject private var router : HomeRouter
    var body: some View {
        VStack(spacing: 0 ) {
            ForEach(ProfileOptions.allCases) { option in
                VStack(spacing:0){
                    NavigationLink(value: HomeRoutes.profileOptions(option.routes)){
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
}

