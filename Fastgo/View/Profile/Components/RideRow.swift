//
//  RideRow.swift
//  Fastgo
//
//  Created by vishwas on 1/12/26.
//
import SwiftUI

struct RideRowView: View {
    let ride : RideStatusModel
    var body: some View {
        HStack(spacing:18){
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            VStack(alignment:.leading,spacing:8){
                Text(ride.location)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                
                Text(ride.date)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .lineLimit(1)
            .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            Text(String(format: "-$%.2f", abs(ride.fare)))
                .foregroundStyle(.red)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
