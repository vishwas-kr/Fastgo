//
//  PromoCodeView.swift
//  Fastgo
//
//  Created by vishwas on 1/12/26.
//

import SwiftUI

struct PromoCodeView: View {
    @State var text = ""
    @FocusState var isSelected : Bool
    var body: some View {
        VStack (alignment: .leading, spacing: 22){
            HStack{
                TextField("Type coupon code", text: $text)
                    .focused($isSelected)
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundStyle(text.isEmpty ? .gray : .black)
                    .accessibilityHint("Type coupon code", isEnabled: isSelected)
                    .padding()
                    
                
                if isSelected && !text.isEmpty {
                    Image(systemName:"xmark.circle.fill")
                          .font(.title3)
                          .padding()
                          .onTapGesture {
                              text = ""
                          }
                }
                    
            }
            .background(isSelected ? . green.opacity(0.1) : .white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke( isSelected ? .green : .gray , lineWidth: 1)
            )
            .padding(.top,26)
            .padding(.bottom, 12)
            
            Text("Available Promo Codes")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView{
                ForEach(0..<1, id:\.self){promo in
                    PromoCodeCapsule()
                }
            }
           
            Spacer()

            CustomGreenButton(action: {}, title: "Add")
        }
        .padding()
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Promo Codes")
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                CustomToolBarBackButton()
            }
        }
    }
}

#Preview {
    PromoCodeView()
}
