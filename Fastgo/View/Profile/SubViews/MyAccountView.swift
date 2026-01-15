//
//  MyAccountView.swift
//  Fastgo
//
//  Created by vishwas on 1/13/26.
//

import SwiftUI

struct MyAccountView: View {
    @State var text = ""
    @FocusState var isFocused : Bool
    @State var selectedGender : Gender = .none
    var body: some View {
        VStack(alignment: .leading){
            HStack(spacing: 12){
                Image("girl")
                    .resizable()
                    .frame(width:70,height:70)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.headline)
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(.green)
                            .clipShape(Circle())
                        ,alignment: .bottomTrailing
                    )
                    .padding(.trailing, 8)
                
                VStack(alignment:.leading) {
                    Text("Dani Alves")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Text("User id: Dani@487")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .leading)
                Spacer()
                Button(action: {}){
                    Text("Change Photo")
                        .font(.footnote)
                    
                    
                }
                .padding(12)
                .foregroundStyle(.green)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.green)
                )
            }
            .padding(.vertical,24)
            
            VStack(spacing: 12) {
                MyAccountTextField(title: "Name", text: $text)
                MyAccountTextField(title: "Date of birth", text: $text)
                MyAccountTextField(title: "About yourself", text: $text)
            }
            
            Text("Gender")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.vertical)
            HStack{
                MyAccountGenderBox(image: "\u{2642}",gender: .male,selectedGender: $selectedGender)
                Spacer()
                MyAccountGenderBox(image: "\u{2640}",gender: .female,selectedGender: $selectedGender)
            }
            
            Spacer()
            CustomGreenButton(action: {}, title: "Save")
        }
        .padding()
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
        .navigationTitle("My Account")
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                CustomToolBarBackButton()
            }
        }
    }
}

#Preview {
    MyAccountView()
}
