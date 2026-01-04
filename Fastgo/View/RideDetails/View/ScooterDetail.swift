//
//  ScooterDetails.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//
import SwiftUI

struct ScooterDetail: View {
    var body: some View {
        HStack(alignment:.top){
            RoundedRectangle(cornerRadius: 24)
                .fill(.cyan.opacity(0.5))
                .frame(maxWidth: 180, maxHeight: 180)
                .overlay(
                    Image("scooter")
                        .resizable()
                        .scaledToFit()
                        .offset(x:0,y:-20)
                        .rotationEffect(Angle(degrees: -10))
                )
            Spacer()
            VStack(alignment:.leading,spacing: 3){
                Text("Electric Scooter")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
                
                Text("Scooter Flash")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 0)
                
                HStack{
                    Image(systemName: "bolt.circle")
                        .font(.title2)
                        .foregroundStyle(.green)
                    Text("90%")
                        .font(.callout)
                        .fontWeight(.semibold)
                    Divider()
                        .background(.white)
                        .frame(height: 20)
                    Text("~20 km")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                .padding(6)
                .foregroundStyle(.white)
                .background(.black)
                .clipShape(Capsule())
                .padding(.bottom,10)
                
                Text("Free for the first ride")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(8)
                    .foregroundStyle(.green)
                    .background(.green.opacity(0.2))
                    .clipShape(RoundedCorners(radius:5, corners: .allCorners))
                
                Text("$0.39/min + tax")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(8)
                    .foregroundStyle(.blue)
                    .background(.blue.opacity(0.2))
                    .clipShape(RoundedCorners(radius:5, corners: .allCorners))
            }
            
        }
        .padding(.top,22)
        .padding()
    }
}


