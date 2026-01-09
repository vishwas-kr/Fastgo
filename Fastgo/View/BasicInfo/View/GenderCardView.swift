//
//  GenderCardView.swift
//  Fastgo
//
//  Created by vishwas on 12/30/25.
//

import SwiftUI

struct GenderCardView: View {
    @Binding var selectedGender : Gender
    var body: some View {
        HStack (spacing:20){
            GenderBox(image: "man", gender: .male, selectedGender: $selectedGender)
            GenderBox(image: "women", gender: .female, selectedGender: $selectedGender)
        }.padding(.vertical,22)
    }
}

#Preview {
    GenderCardView(selectedGender: .constant(.male))
}

struct GenderBox: View {
    let image : String
    let gender: Gender
    @Binding var selectedGender : Gender
    var isSelected : Bool {
        selectedGender == gender
    }
    var body: some View {
        VStack{
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 120)
            Text(gender.rawValue)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: UIScreen.main.bounds.width/2.5 ,maxHeight: 180)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(isSelected ? 0.1 : 0.08),
                    radius: isSelected ? 8 : 4,
                    x: 0,
                    y: isSelected ? 6 : 3
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12,)
                .fill(.yellow.opacity(0.05))
                .stroke(isSelected ?.green : .white ,lineWidth: 1 )
            
            
        )
        .onTapGesture {
            selectedGender = gender
        }
        
        
    }
}
