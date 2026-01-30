//
//  ScooterDetails.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//
import SwiftUI

struct ScooterDetail: View {
    let annotation: ScooterAnnotation
    
    var body: some View {
        HStack(alignment:.top){
            RoundedRectangle(cornerRadius: 24)
                .fill(.cyan.opacity(0.5))
                .frame(maxWidth: 180, maxHeight: 180)
                .overlay(
                    Image(annotation.scooter.imageName)
                        .resizable()
                        .scaledToFit()
                        .offset(x:0,y:-20)
                        .rotationEffect(Angle(degrees: -10))
                )
                .padding(.trailing,8)
            VStack(alignment:.leading,spacing: 3){
                Text(annotation.scooter.typeName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
                
                Text(annotation.scooter.uniqueCode)
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .padding(.bottom, 0)
                
                HStack{
                    Image(systemName: "bolt.circle")
                        .font(.title2)
                        .foregroundStyle(.green)
                    Text("\(annotation.scooter.battery)%")
                        .font(.callout)
                        .fontWeight(.semibold)
                    Divider()
                        .background(.white)
                        .frame(height: 20)
                    Text("~\(annotation.scooter.rangeKm) km")
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
                
                Text(String(format: "$%.2f/min + tax", annotation.scooter.perMinCost))
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
