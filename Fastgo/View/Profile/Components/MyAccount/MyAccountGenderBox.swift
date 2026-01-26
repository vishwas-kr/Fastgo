//
//  MyAccountGenderBox.swift
//  Fastgo
//
//  Created by vishwas on 1/13/26.
//

import SwiftUI

struct MyAccountGenderBox: View {
    let image : String
    let gender: Gender
    @Binding var selectedGender : Gender
    var isSelected : Bool {
        selectedGender == gender
    }
    
    var body: some View {
        HStack(spacing:12){
            Text(image)
                .font(.headline)
                .fontWeight(.semibold)
            Text(gender.rawValue)
                .font(.headline)
                .fontWeight(.semibold)
            if isSelected { Image(systemName:"checkmark.circle.fill")
                .foregroundStyle(.green)}
        }
        .padding()
        .frame(maxWidth: UIScreen.main.bounds.width/2.5 ,maxHeight: 45)
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
        .onTapGesture {
            selectedGender = gender
        }
        
        
    }
}
