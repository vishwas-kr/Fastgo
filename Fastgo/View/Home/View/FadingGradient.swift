//
//  FadingGradient.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI

struct FadingGradient: View {
    let color1 : Color
    let color2 : Color
    let location1 : CGFloat
    let location2 : CGFloat
    let startPoint : UnitPoint
    let endPoint : UnitPoint
    var body: some View {
        LinearGradient(
            stops: [
                .init(color: color1, location: location1),
                .init(color: color2, location: location2)
            ],
            startPoint: startPoint,
            endPoint: endPoint
        )
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
