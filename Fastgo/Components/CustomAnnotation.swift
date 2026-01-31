//
//  CustomAnnotation.swift
//  Fastgo
//
//  Created by vishwas on 1/31/26.
//

import SwiftUI

struct CustomAnnotation: View {
    let image : String
    let powerColor : Color
    var body: some View {
        Circle()
            .fill(.black)
            .stroke(.white, lineWidth:4)
            .frame(width:45,height:45)
            .overlay{
                VStack(spacing: 0){
                    Image(image)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width:18,height:18)
                    
                    Image("power")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(powerColor)
                        .frame(width:8,height:8)
                        .rotationEffect(Angle(degrees:90))
                }
                .overlay{
                    Image(systemName:"triangle.fill")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width:10,height:10)
                        .rotationEffect(Angle(degrees:180))
                        .offset(y:27)
                }
            }
    }
}
