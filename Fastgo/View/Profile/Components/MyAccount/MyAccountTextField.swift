//
//  MyAccountTextField.swift
//  Fastgo
//
//  Created by vishwas on 1/13/26.
//
import SwiftUI
struct MyAccountTextField: View {
    let title: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField(title, text: $text)
            .focused($isFocused)
            .font(.headline)
            .fontWeight(.regular)
            .foregroundStyle(text.isEmpty ? .gray : .black)
            .padding()
            .accessibilityHint("Type coupon code", isEnabled: isFocused)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.white))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke( isFocused ? .green : .white , lineWidth: 1)
            )
    }
}
