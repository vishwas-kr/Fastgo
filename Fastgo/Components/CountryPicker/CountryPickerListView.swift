//
//  CountryPickerListView.swift
//  Fastgo
//
//  Created by vishwas on 12/26/25.
//

import SwiftUI

struct CountryPickerListView: View {
    @Binding var selectedCountry: Country
    @Environment(\.dismiss) var dismiss
    
    let countries: [Country] = CountryConstant.countries
    
    var body: some View {
        NavigationView {
            List(countries) { country in
                HStack {
                    Text(country.flag)
                    Text(country.name)
                    Spacer()
                    Text(country.dialCode)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCountry = country
                    dismiss()
                }
            }
            .navigationTitle("Select Country")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let country = Country(name: "United States", code: "US", dialCode: "+1")
    CountryPickerListView(selectedCountry:.constant(country))
}
