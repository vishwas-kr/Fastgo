//
//  OnboardingText.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI

struct OnboardingText: View {
    let page : OnboardingPage
    var body: some View {
        VStack(spacing: 16) {
            Text(page.title)
                .font(.title)
                .foregroundColor(.black)
                .fontWeight(.semibold)
            Text(page.description)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }.padding(.bottom, 32)
    }
}
