//
//  Date.swift
//  Fastgo
//
//  Created by vishwas on 1/30/26.
//

import Foundation

extension Date {
    
    static func rideDateFormatter(_ date: Date) -> String {
        let calendar = Calendar.current
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "h:mm a"
        
        if calendar.isDateInToday(date) {
            return "Today, \(timeFormatter.string(from: date))"
        }
        
        if calendar.isDateInYesterday(date) {
            return "Yesterday, \(timeFormatter.string(from: date))"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        return "\(dateFormatter.string(from: date)), \(timeFormatter.string(from: date))"
    }
}
