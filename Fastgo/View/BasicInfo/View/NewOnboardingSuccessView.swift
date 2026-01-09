//
//  SuccessView.swift
//  Fastgo
//
//  Created by vishwas on 12/30/25.
//

import SwiftUI

struct NewOnboardingSuccessView: View {
    @State private var pop = false
    var body: some View {
        VStack{
            Image("verified")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200)
                .scaleEffect(pop ? 1: 0)
                .opacity(pop ? 1 : 0)
            
            
            VStack(spacing:8){
                Text("Congratulations")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Now you can use the app!")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .padding()
            .scaleEffect(pop ? 1 : 0.8)
            .opacity(pop ? 1 : 0)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                pop = true
            }
        }
        .onAppear{
            Task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    AppStateManager.shared.completeBasicInfo()
                }
        }
    }
}

#Preview {
    NewOnboardingSuccessView()
}
