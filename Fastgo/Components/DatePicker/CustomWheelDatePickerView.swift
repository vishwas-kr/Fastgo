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
    
    let months = Calendar.current.monthSymbols
    let years = Array(1990...2026)
    
    var days: [Int] {
        let monthIndex = months.firstIndex(of: month)! + 1
        let date = calendar.date(from: DateComponents(year: year, month: monthIndex))!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return Array(range)
    }
    
    init() {
        let components = Calendar.current.dateComponents([.month, .day, .year], from: Date())
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
        }
        .onChange(of: year) { _, _ in
            adjustDayIfNeeded()
        }
    }
    
    private func adjustDayIfNeeded() {
        if !days.contains(day) {
            day = days.last!
        }
    }
}

#Preview {
    CustomWheelDatePickerView()
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
                                let itemCenter = itemGeo.frame(in: .global).midY
                                let distance = abs(itemCenter - centerY - geo.frame(in: .global).minY)
                                
                                Text(item.description)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(
                                        distance < rowHeight / 2 ? .black : .gray
                                    )
                                    .frame(height: rowHeight)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(height: rowHeight)
                            .id(item)
                        }
                    }
                    .padding(.vertical, (geo.size.height - rowHeight) / 2)
                }
                .onAppear {
                    proxy.scrollTo(selection, anchor: .center)
                }
                .onChange(of: selection) { _, newValue in
                    withAnimation(.easeOut) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { _ in
                            snapToNearest(proxy: proxy, geometry: geo)
                        }
                )
            }
        }
    }
    
    
    private func snapToNearest(proxy: ScrollViewProxy, geometry: GeometryProxy) {
        let center = geometry.size.height / 2
        
        var closest: (item: T, distance: CGFloat)?
        
        for item in items {
            _ = item
            if let frame = geometry.frame(in: .global).origin.y as CGFloat? {
                let distance = abs(frame - center)
                if closest == nil || distance < closest!.distance {
                    closest = (item, distance)
                }
            }
        }
        
        if let selected = closest?.item {
            selection = selected
            withAnimation(.easeOut) {
                proxy.scrollTo(selected, anchor: .center)
            }
        }
    }
}
