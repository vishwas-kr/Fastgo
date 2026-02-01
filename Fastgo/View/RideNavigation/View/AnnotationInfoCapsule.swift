//
//  AnnotationInfoCapsule.swift
//  Fastgo
//
//  Created by vishwas on 1/31/26.
//

import SwiftUI

struct AnnotationInfoCapsule : View {
    let timeData : String
    let distanceData : String
    let isVisible : Bool
    
    var body : some View {
        if isVisible {
            HStack {
                CapsuleComponent(image: "clock", title: timeData)
                Divider()
                    .background(.white)
                    .frame(height: 10)
                CapsuleComponent(image: "arrow.swap", title: distanceData)
            }
            .padding(8)
            .foregroundStyle(.white)
            .background(.black)
            .clipShape(Capsule())
            .transition(.scale.combined(with: .opacity))
        }
    }
}
