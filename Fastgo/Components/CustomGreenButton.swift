//
//  CustomGreenButton.swift
//  Fastgo
//
//  Created by vishwas on 1/10/26.
//

import SwiftUI

struct CustomGreenButton: View {
    let action: () -> Void
    let title : String
    let imageName : String?
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let imageName {
                    Image(systemName: imageName )
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 65)
            .background(Color.green)
            .clipShape(Capsule())
        }
    }
}
