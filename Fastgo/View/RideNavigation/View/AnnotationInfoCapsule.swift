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
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0.8)
        .animation(.easeInOut(duration: 0.2), value: isVisible)
    }
}
