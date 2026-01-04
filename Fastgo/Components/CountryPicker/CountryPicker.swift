//
//  CountryPicker.swift
//  Fastgo
//
//  Created by vishwas on 12/26/25.
//

import SwiftUI

struct CountryPicker: View {
    @State private var selectedCountry: Country = Country(name: "India", code: "IN", dialCode: "+91")
    @State private var showingCountryPicker = false
    var body: some View {
        Button(action: {
            showingCountryPicker.toggle()
        }) {
            HStack {
                Text(selectedCountry.flag)
                Text(selectedCountry.dialCode)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
                Image(systemName: "chevron.down")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemGray2))
            }
            .padding(.vertical, 10)
        }
        .padding()
        .sheet(isPresented: $showingCountryPicker) {
            CountryPickerListView(selectedCountry: $selectedCountry)
        }
    }
}

//#Preview {
//    CountryPicker()
//}
