//
//  PaymentView.swift
//  Fastgo
//
//  Created by vishwas on 1/13/26.
//

import SwiftUI

struct PaymentView: View {
    @State var text = ""
    @State var currentCard: Int = 1
    var body: some View {
        VStack{
            PaymentTypeSelector()
            
            ZStack(){
                RoundedRectangle(cornerRadius: 22,style: .continuous)
                    .fill(.purple)
                
                VStack(alignment: .leading){
                    HStack {
                        Text("9862 9182 1203 0978")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "radiowaves.right")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    HStack{
                        Text("01/31")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.trailing, 22)
                        Text("CVV")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Image("visa")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 86,height:86)
                            .clipped()
                        
                    }
                }
                .foregroundStyle(.white)
                .padding(30)
            }
            .frame(height: 220)
            
            progressBar
            
            Text("Card Details")
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity,alignment:.leading)
                .padding(.vertical)
               
            MyAccountTextField(title: "Card Number", text: $text)
            Spacer()
            CustomGreenButton(action: {}, title: "Add",imageName: nil)
        }
        .padding()
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Payment Method")
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                CustomToolBarBackButton()
            }
        }
    }
    
    private var progressBar: some View {
        HStack{
            ForEach(0..<BasicInfo.allCases.count, id:\.self){index in
                Rectangle()
                    .foregroundColor(index == currentCard ? .green : .gray.opacity(0.2))
                    .frame(maxWidth: index == currentCard ? 35 : 8, maxHeight: 8)
                    .cornerRadius(12)
                    .animation(.spring(), value:currentCard)
            }
        }.padding(.vertical,12)
    }
}

#Preview {
    PaymentView()
}

struct PaymentTypeSelector: View {
    enum PaymentType {
        case bank
        case card
    }
    
    @State private var selected: PaymentType = .bank
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
