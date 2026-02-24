//
//  FSTextField.swift
//  Fastgo
//
//  Created by vishwas on 2/24/26.
//

import SwiftUI

struct FSTextField : View {
    @Binding var text : String
    let placeholder : String
    let font : Font
    var fontWeight : Font.Weight = .regular
    var backgroundColor : Color = Color(.systemBackground)
    var keyBoardType : UIKeyboardType = .default
    var isBorderVisible : Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body : some View {
        TextField(placeholder,text: $text)
            .focused($isFocused)
            .font(font)
            .fontWeight(fontWeight)
            .padding()
            .foregroundStyle(.primary)
            .keyboardType(keyBoardType)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill( isFocused ? .green.opacity(0.1) : backgroundColor))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke( isFocused ? Color.green : Color(.systemGray4),
                             lineWidth: isBorderVisible ? 1 : 0
                           )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}


#Preview {
    FSTextField(text: .constant(""), placeholder: "Enter your name", font: .body, backgroundColor: .pink)
}
