//
//  PromoPill.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI

struct PromoPill: View {
    let title : String
    let description : String
    let image : String
    let backgroundColor : Color
    var body: some View {
        HStack{
            Image(image)
                .resizable()
                .scaledToFit()
                .padding(8)
                .frame(width: 60, height: 60)
                .background(backgroundColor)
                .clipShape(Circle())
            VStack(alignment: .leading){
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
                
                Text(description)
                    .font(.subheadline)
                    .fontWeight(.light)
            }
        }
        .frame(width:UIScreen.main.bounds.width * 0.7,alignment: .leading)
        .padding(4)
        
        .background(.white)
        .clipShape(Capsule())
        .padding(.vertical)
        .padding(.trailing,8)
    }
}


