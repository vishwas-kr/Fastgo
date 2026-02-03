//
//  FinishRideCard.swift
//  Fastgo
//
//  Created by vishwas on 2/2/26.
//
import SwiftUI

struct FinishRideCard: View {
    let image : String
    let title : String
    let desc : String
    var body: some View {
            RoundedRectangle(cornerRadius: 18).fill(.white)
                .frame(height: 100)
                .overlay{
                    HStack(alignment: .top,spacing: 18){
                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        VStack(alignment:.leading, spacing: 12){
                            Text(title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                            Text(desc)
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
    }
}
