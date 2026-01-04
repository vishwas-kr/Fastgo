//
//  DateOfBirthView.swift
//  Fastgo
//
//  Created by vishwas on 12/30/25.
//

import SwiftUI

struct DateOfBirthView: View {
    var body: some View {
        VStack{
            CustomWheelDatePickerView()
                .padding(.vertical,22)
        }
    }
}

#Preview {
    DateOfBirthView()
}
