//
//  CustomToolBarBackButton.swift
//  Fastgo
//
//  Created by vishwas on 1/2/26.
//

import SwiftUI

struct CustomToolBarBackButton: View {
    @EnvironmentObject private var router : HomeRouter
    var foregroundColor : Color = .black
    var backgroundColor : Color = .white
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            if let action = action {
                action()
            } else {
                router.navigatePop()
            }
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(Color(foregroundColor))
                .padding(13)
                .background(Color(backgroundColor), in: .circle)
                .shadow(color: .black.opacity(0.1),radius:10,x:10,y:5)
        }
    }
}
