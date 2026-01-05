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
                VStack(alignment:.leading){
                    HStack(spacing: 22){
                        Image("girl")
                            .resizable()
                            .frame(width:100,height:100)
                            .overlay(
                                Image(systemName: "pencil")
                                    .font(.headline)
                                    .padding(8)
                                    .foregroundStyle(.white)
                                    .background(.green)
                                    .clipShape(Circle())
                                ,alignment: .bottomTrailing
                            )
                        
                        VStack(alignment:.leading) {
                            Text("Dani Alves")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("User id: Dani@487")
                                .font(.headline)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.bottom,22)
                    HStack {
                        RideInfo(title: "Kilometers", image: "girl", value: "134.2 km")
                        Spacer()
                        RideInfo(title: "Total Rides", image: "boy", value: "43")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 18).fill(.green.opacity(0.1)))
                    
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 22).fill(.white))
                Spacer()
            }.padding(22)
        }.background(Color(.systemGray6))
    }
}

#Preview {
    ProfileView()
}



struct RideInfo: View {
    let title : String
    let image : String
    let value : String
    var body: some View {
        HStack(spacing: 12){
            Image(image)
                .resizable()
                .frame(width:50,height:50)
            
            
            VStack(alignment:.leading, spacing: 8) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
                Text(value)
                    .font(.callout)
                    .fontWeight(.semibold)
            }
        }
    }
}
