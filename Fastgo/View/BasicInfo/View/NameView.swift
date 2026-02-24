//
//  NameView.swift
//  Fastgo
//
//  Created by vishwas on 12/30/25.
//

import SwiftUI

struct NameView: View {
    @Binding var name : String
    var body: some View {
        FSTextField(text: $name, placeholder: "Enter your name", font: .headline, fontWeight: .semibold, isBorderVisible: true)
    }
}

#Preview {
    NameView(name: .constant("Vish"))
}

struct BasicInfoHeaderView : View {
    let title: String
    let description: String
    var body : some View {
        VStack(spacing:16){
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            Text(description)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundStyle(.gray)
        }.padding(.vertical, 22)
    }
}
