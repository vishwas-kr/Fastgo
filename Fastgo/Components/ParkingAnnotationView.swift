//
//  ParkingAnnotationView.swift
//  Fastgo
//
//  Created by vishwas on 2/1/26.
//

import SwiftUI

struct ParkingAnnotationView: View {
    var body: some View {
        MapAnnotationContainer {
            Circle()
                .fill(.white)
                .stroke(.white, lineWidth: 4)
                .frame(width: 45, height: 45)
                .overlay {
                    VStack(spacing: 0) {
                        Image(systemName: "p.circle.fill")
                            .font(.system(size: 34))
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(.blue)
                    }
                }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        ParkingAnnotationView()
    }
}
