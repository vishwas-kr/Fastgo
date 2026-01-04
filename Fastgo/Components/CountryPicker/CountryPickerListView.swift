//
//  CountryPickerListView.swift
//  Fastgo
//
//  Created by vishwas on 12/26/25.
//

import SwiftUI

struct CountryPickerListView: View {
    @Binding var selectedCountry: Country
    @Environment(\.dismiss) var dismiss // Use @Environment to dismiss the sheet
    
    // In a real app, load this data from a JSON file or NSLocale
    let countries: [Country] = CountryConstant.countries // Sort alphabetically
    
    var body: some View {
        NavigationView {
            List(countries) { country in
                HStack {
                    Text(country.flag)
                    Text(country.name)
                    Spacer()
                    Text(country.dialCode)
                }
                .contentShape(Rectangle()) // Make the whole row tappable
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
