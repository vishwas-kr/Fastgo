//
//  DateOfBirthView.swift
//  Fastgo
//
//  Created by vishwas on 12/30/25.
//

import SwiftUI

struct DateOfBirthView: View {
    @Binding var dateOfBirth : Date
    var body: some View {
        VStack{
            CustomWheelDatePickerView(selectedDate: $dateOfBirth)
                .padding(.vertical,22)
        }
    }
}

#Preview {
    DateOfBirthView(dateOfBirth: .constant(Date()))
}
