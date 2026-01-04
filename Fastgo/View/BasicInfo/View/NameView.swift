//
//  NameView.swift
//  Fastgo
//
//  Created by vishwas on 12/30/25.
//

import SwiftUI

struct NameView: View {
    @FocusState var isFocused : Bool
    @State var name = ""
    var body: some View {
        TextField("Your name",text:$name)
            .focused($isFocused)
            .font(.headline)
            .fontWeight(.semibold)
            .padding()
            .foregroundStyle(Color(.systemGray4))
            .frame(maxWidth: .infinity,maxHeight: 55)
            .background(.green.opacity(isFocused ? 0.02 : 0))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.green : Color(.systemGray4), lineWidth: 1)
            )
    }
}

#Preview {
    NameView()
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
