//
//  ProfileCard.swift
//  Fastgo
//
//  Created by vishwas on 1/11/26.
//
import SwiftUI

struct ProfileCard: View {
    @Binding var userData : UserProfile?
    var body: some View {
        VStack(alignment:.leading){
            HStack(spacing: 22){
                AvatarView(showEditButton: true)
                VStack(alignment:.leading) {
                    Text("\(userData?.name ?? "Fetching...")")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                    Text("User id: \(userData?.name ?? "@fastago")")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.bottom,22)
            HStack {
                RideInfoBox(title: "Kilometers", image: "girl", value: "\(userData?.totalDistance ?? 0.0) km")
                Spacer()
                RideInfoBox(title: "Total Rides", image: "boy", value: "\(userData?.totalRides ?? 0)")
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 18).fill(.green.opacity(0.1)))
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 22).fill(.white))
    }
}
