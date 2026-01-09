//
//  CustomAppBar.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI

struct CustomAppBar: View {
    var body: some View {
        HStack{
            Image("boy")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            Spacer()
            VStack(spacing:8){
                HStack{
                    Image(systemName: "location.fill")
                        .foregroundStyle(.green)
                    Text("Your location")
                        .font(.callout)
                        .fontWeight(.light)
                        .foregroundStyle(.gray)
                }
                Text("Texas, 30 avenue")
                    .font(.headline)
                    .fontWeight(.light)
                    .lineLimit(1)
            }.frame(maxWidth: 200)
            Spacer()
            Button(action:{
                Task{ await  AppStateManager.shared.signOut()}
            },label: {
                Image(systemName: "bell")
                    .font(.title)
                    .foregroundStyle(.black)
                    .frame(width: 60, height: 60)
                    .background(.white)
                    .clipShape(Circle())
            })
        }.frame(height: 60)
    }
}

