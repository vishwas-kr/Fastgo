//
//  CustomToolBarBackButton.swift
//  Fastgo
//
//  Created by vishwas on 1/2/26.
//

import SwiftUI

struct CustomToolBarBackButton: View {
    @EnvironmentObject private var router : HomeRouter
    var body: some View {
        Button {
            router.navigatePop()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(.black)
                .padding(13)
                .background(.white, in: .circle)
                .shadow(color: .black.opacity(0.1),radius:10,x:10,y:5)
        }
    }
}
