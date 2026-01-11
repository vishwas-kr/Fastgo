//
//  RideInfoBox.swift
//  Fastgo
//
//  Created by vishwas on 1/11/26.
//

import SwiftUI


struct RideInfoBox: View {
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
                    .foregroundStyle(.black)
            }
        }
    }
}

