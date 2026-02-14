//
//  PaymentTypeSelector.swift
//  Fastgo
//
//  Created by vishwas on 1/13/26.
//

import SwiftUI

struct PaymentTypeSelector: View {
    @Binding var selected: PaymentType
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            segmentButton(title: "Bank", type: .bank)
            segmentButton(title: "Credit Card", type: .card)
        }
        .background(
            Capsule()
                .fill(.white)
        )
        .padding()
    }
    
    @ViewBuilder
    private func segmentButton(title: String, type: PaymentType) -> some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                selected = type
            }
        } label: {
            Text(title)
                .font(.headline)
                .fontWeight(.regular)
                .foregroundColor(selected == type ? .white : .green)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        if selected == type {
                            Capsule()
                                .fill(Color.green)
                                .matchedGeometryEffect(id: "selection", in: animation)
                        }
                    }
                )
        }
    }
}
