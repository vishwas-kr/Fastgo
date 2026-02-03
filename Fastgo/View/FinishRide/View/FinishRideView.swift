//
//  FinishRideView.swift
//  Fastgo
//
//  Created by vishwas on 2/2/26.
//

import SwiftUI

struct FinishRideView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom){
                VStack {
                    Image(AssetImage.FinishRide.background)
                        .resizable()
                        .scaledToFill()
                        .frame(width:geo.size.width, height:geo.size.height * 0.37)
                        .ignoresSafeArea()
                    
                    Spacer()
                }
                VStack(spacing:0){
                    RoundedRectangle(cornerRadius: 40)
                        .frame(height: UIScreen.main.bounds.height * 0.72)
                        .foregroundStyle(Color(.systemGray6))
                        .overlay(
                            VStack{
                                header
                                
                                ForEach(FinishRideData.allCases, id:\.self){ data in
                                    FinishRideCard(image: data.image, title: data.title, desc: data.desc)
                                }
                                
                                CustomGreenButton(action: {}, title: "Take a photo", imageName: "camera")
                                    .padding(.top,12)
                            }
                                .padding()
                        )
                }
                .frame(width:geo.size.width, height:geo.size.height * 0.7)
                
            }
            .background(Color(.systemGray6))
            .navigationBarBackButtonHidden(true)
        }
    }
    private var header : some View {
        VStack(alignment: .leading, spacing: 18){
            Text("Finish Ride")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
            
            Text("Don't block the pathways, take the photo to verify parking and end your ride.")
                .font(.subheadline)
                .foregroundStyle(.gray)
            
        }
        .padding(.bottom,22)
    }
}

#Preview {
    FinishRideView()
}
