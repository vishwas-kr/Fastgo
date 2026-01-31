//
//  CapsuleComponent.swift
//  Fastgo
//
//  Created by vishwas on 1/31/26.
//

import SwiftUI

struct CapsuleComponent : View {
    let image : String
    let title : String
    var body : some View {
        HStack {
            Image(systemName: image)
                .font(.title3)
                .foregroundStyle(.green)
            Text(title)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
    }
}
