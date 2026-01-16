//
//  LocationButton.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI

struct LocationButton: View {
    let viewModel : MapViewModel
    var body: some View {
        HStack {
            Spacer()
            Button(action:{
                viewModel.centerUserLocation()
            },label: {
                Image(systemName: "scope")
                    .font(.title)
                    .foregroundStyle(.green)
                    .frame(width: 60, height: 60)
                    .background(.white)
                    .clipShape(Circle())
            }).padding()
        }
    }
}

