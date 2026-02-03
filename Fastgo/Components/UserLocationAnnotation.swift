//
//  UserLocationAnnotation.swift
//  Fastgo
//
//  Created by vishwas on 2/1/26.
//

import SwiftUI

struct UserLocationAnnotation: View {
    let isRiding: Bool
    
    var body: some View {
        ZStack {
            if isRiding {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "location.north.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                    }
                    .shadow(color: .purple.opacity(0.4), radius: 8, x: 0, y: 4)
            } else {
                MapAnnotationContainer{
                    Circle()
                        .fill(.white)
                        .frame(width: 45, height: 45)
                        .overlay {
                            Image(AssetImage.Map.user)
                                .resizable()
                                .scaledToFill()
                             .frame(width: 38, height: 38)
                                .clipShape(Circle())
                        }
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        UserLocationAnnotation(isRiding: false)
        UserLocationAnnotation(isRiding: true)
    }
}
