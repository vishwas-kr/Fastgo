//
//  PaymentCardUI.swift
//  Fastgo
//
//  Created by vishwas on 2/14/26.
//

import SwiftUI

struct PaymentCardUI: View {
    let number: String
    let expiry: String
    let cvv: String
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(color)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(number)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "radiowaves.right")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                Spacer()
                HStack {
                    Text(expiry)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.trailing, 22)
                    Text(cvv)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    Image("visa")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 86, height: 86)
                        .clipped()
                }
            }
            .foregroundStyle(.white)
            .padding(30)
        }
    }
}
