//
//  ProfileCard.swift
//  Fastgo
//
//  Created by vishwas on 1/11/26.
//
import SwiftUI

struct ProfileCard: View {
    var body: some View {
        VStack(alignment:.leading){
            HStack(spacing: 22){
                Image("girl")
                    .resizable()
                    .frame(width:70,height:70)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.headline)
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(.green)
                            .clipShape(Circle())
                        ,alignment: .bottomTrailing
                    )
                
                VStack(alignment:.leading) {
                    Text("Dani Alves")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                    Text("User id: Dani@487")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.bottom,22)
            HStack {
                RideInfoBox(title: "Kilometers", image: "girl", value: "134.2 km")
                Spacer()
                RideInfoBox(title: "Total Rides", image: "boy", value: "43")
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 18).fill(.green.opacity(0.1)))
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 22).fill(.white))
    }
}
