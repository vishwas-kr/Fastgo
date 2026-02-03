//
//  Country.swift
//  Fastgo
//
//  Created by vishwas on 12/26/25.
//

import Foundation

struct Country: Identifiable, Hashable {
    public let id = UUID()
    let name: String
    let code: String
    var dialCode: String
    
    var flag: String {
        let base: UInt32 = 127397
        var s = ""
        for v in code.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}
