//
//  PromoCodeCapsule.swift
//  Fastgo
//
//  Created by vishwas on 1/13/26.
//
import SwiftUI
struct PromoCodeCapsule: View {
    var body: some View {
        HStack(spacing:22){
            Image(AssetImage.Profile.promoCode)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(.purple.opacity(0.1))
                .clipShape(Circle())
            VStack(alignment:.leading){
                Text("5$ off one ride")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                Text("Valid upto 5$ one ride.")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                
                Text("Expires on Nov 15, 2026")
                    .font(.caption)
                    .foregroundStyle(.black)
                    .padding(4)
                    .padding(.horizontal,4)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
            }
            Spacer()
        }
        .padding()
        .background(.white)
        .clipShape(Capsule())
    }
}
