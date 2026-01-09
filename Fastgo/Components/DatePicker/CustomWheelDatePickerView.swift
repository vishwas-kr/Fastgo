//
//  DatePickerView.swift
//  Fastgo
//
//  Created by vishwas on 12/29/25.
//

import SwiftUI

struct CustomWheelDatePickerView: View {
    
    private let calendar = Calendar.current
    private let today = Date()
    
    @State private var month: String
    @State private var day: Int
    @State private var year: Int
    @Binding var selectedDate: Date
    
    let months = Calendar.current.monthSymbols
    let years = Array(1990...2026)
    
    var days: [Int] {
        let monthIndex = months.firstIndex(of: month)! + 1
        let date = calendar.date(from: DateComponents(year: year, month: monthIndex))!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return Array(range)
    }
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let components = Calendar.current.dateComponents([.month, .day, .year], from: selectedDate.wrappedValue)
        _month = State(initialValue: Calendar.current.monthSymbols[components.month! - 1])
        _day = State(initialValue: components.day!)
        _year = State(initialValue: components.year!)
    }
    
    
    
    var body: some View {
        HStack(spacing: 0) {
            
            WheelPicker(items: months, selection: $month)
            
            WheelPicker(items: days, selection: $day)
            
            WheelPicker(items: years, selection: $year)
        }
        .frame(height: 300)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green, lineWidth: 1)
                .frame(height: 66)
        )
        .mask(
            LinearGradient(
                colors: [.clear, .black, .black, .clear],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onChange(of: month) { _, _ in
            adjustDayIfNeeded()
            updateSelectedDate()
        }
        .onChange(of: day) { _, _ in
            updateSelectedDate()
        }
        .onChange(of: year) { _, _ in
            adjustDayIfNeeded()
            updateSelectedDate()
        }
    }
    private func adjustDayIfNeeded() {
        if !days.contains(day) {
            day = days.last!
        }
    }
    
    private func updateSelectedDate() {
        let monthIndex = months.firstIndex(of: month)! + 1
        if let newDate = calendar.date(from: DateComponents(year: year, month: monthIndex, day: day, hour: 12)) {
            selectedDate = newDate
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeZone = calendar.timeZone
        }
    }
}

#Preview {
    CustomWheelDatePickerView(selectedDate: .constant(Date()))
}


struct WheelPicker<T: Hashable & CustomStringConvertible>: View {
    
    let items: [T]
    @Binding var selection: T
    
    let rowHeight: CGFloat = 66
    
    var body: some View {
        GeometryReader { geo in
            let centerY = geo.size.height / 2
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(Array(items.enumerated()), id: \.element) { index, item in
                            GeometryReader { itemGeo in
                                let itemCenter = itemGeo.frame(in: .named("pickerCoordinateSpace")).midY
                                let distance = abs(itemCenter - centerY)
                                let isCentered = distance < rowHeight / 2
                                
                                Text(item.description)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(isCentered ? .black : .gray)
                                    .frame(height: rowHeight)
                                    .frame(maxWidth: .infinity)
                                    .onChange(of: isCentered) { _, newValue in
                                        if newValue {
                                            selection = item
                                        }
                                    }
                            }
                            .frame(height: rowHeight)
                            .id(item)
                        }
                    }
                    .padding(.vertical, (geo.size.height - rowHeight) / 2)
                }
                .coordinateSpace(name: "pickerCoordinateSpace")
                .onAppear {
                    proxy.scrollTo(selection, anchor: .center)
                }
            }
        }
    }
}
