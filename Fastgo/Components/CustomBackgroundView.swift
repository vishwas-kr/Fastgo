//
//  CustomBackgroundView.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//
import SwiftUI

struct CustomBackgroundView<Content: View>: View {
    let imageName: String
    let imageHeightRatio: CGFloat
    @ViewBuilder let content: Content
    
    @StateObject private var keyboard = KeyboardHeightHelper()
    
    init(
        imageName: String,
        imageHeightRatio: CGFloat = 0.65,
        @ViewBuilder content: () -> Content
    ) {
        self.imageName = imageName
        self.imageHeightRatio = imageHeightRatio
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height * imageHeightRatio
                    )
                    .clipped()
                    .ignoresSafeArea()
                
                Spacer()
            }
            content
            
//            VStack {
//                Spacer()
//                content
//            }
//            .offset(y: -keyboard.keyboardHeight * 0.15)
//            .animation(.easeOut(duration: 0.3), value: keyboard.keyboardHeight)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}
