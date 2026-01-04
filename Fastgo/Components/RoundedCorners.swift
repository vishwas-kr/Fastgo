//
//  RoundedCorner.swift
//  Fastgo
//
//  Created by vishwas on 12/26/25.
//

import SwiftUI

struct RoundedCorners: Shape {
    var radius: CGFloat = 40
    var corners: UIRectCorner = [.topLeft, .topRight]
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
