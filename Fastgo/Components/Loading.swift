//
//  Loading.swift
//  Fastgo
//
//  Created by vishwas on 1/9/26.
//
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                LottieAnimation()
                Text("Loading...")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: true)
    }
}
