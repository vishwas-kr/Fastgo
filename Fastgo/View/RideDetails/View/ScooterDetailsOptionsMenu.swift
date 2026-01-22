//
//  ScooterDetailsOptionsMenu.swift
//  Fastgo
//
//  Created by vishwas on 1/22/26.
//

import SwiftUI

struct ScooterDetailsOptionsMenu: View {
    var body: some View {
        VStack(spacing: 0 ) {
            ForEach(ScooterRideMenu.allCases,id:\.self) { index in
                VStack(spacing:0) {
                    HStack (spacing: 16){
                        Image(index.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width:40,height:40)
                            .clipShape(Circle())
                        Text(index.title)
                            .font(.callout)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color(.systemGray2))
                    }
                    .frame(height:28)
                    .padding()
                    
                    if index != ScooterRideMenu.allCases.last { Divider()}
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
        )
    }
}

#Preview {
    ScooterDetailsOptionsMenu()
}
