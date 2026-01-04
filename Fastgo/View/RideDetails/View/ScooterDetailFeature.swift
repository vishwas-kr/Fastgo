//
//  ScooterAction.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI
struct ScooterDetailFeatures: View {
    var body: some View {
        HStack{
            ForEach(ScooterDetailFeature.allCases,id:\.self){index in
                
                HStack{
                    Image(systemName: index.image)
                    Text(index.rawValue)
                        .font(.callout)
                }
                .padding(10)
                .background(.white)
                .clipShape(Capsule())
                
            }
        }
        .padding(.top,22)
        .padding()
    }
}
