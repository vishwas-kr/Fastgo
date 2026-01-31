//
//  SlideToAction.swift
//  Fastgo
//
//  Created by vishwas on 1/31/26.
//
import SwiftUI

struct SldeToAction: View {
    let color: Color
    let title: String
    let completedTitle: String
    let onCompleted: () -> Void
    
    @State private var dragOffset: CGFloat = 0
    @State private var isCompleted = false
    
    var body: some View {
        ZStack(alignment: .center){
            HStack {
                Image(systemName: "chevron.right.2")
                    .font(.title3)
                    .padding()
                    .foregroundStyle(.white)
                    .background(color)
                    .clipShape(Circle())
                    .offset(x:dragOffset)
                    .opacity(isCompleted ? 0 : 1)
                    .gesture(
                        DragGesture()
                            .onChanged{value in
                                let newOffSet = value.translation.width
                                if newOffSet > 0 {
                                    dragOffset = min(newOffSet,260)
                                }
                            }
                            .onEnded {_ in
                                if dragOffset > 180 {
                                    withAnimation(.easeInOut) {
                                        dragOffset = 260
                                        isCompleted = true
                                    }
                                    onCompleted()
                                } else {
                                    withAnimation(.spring()){
                                        dragOffset = 0
                                    }
                                }
                            }
                    )
                    .transition(.scale.combined(with: .opacity))
                Spacer()
            }
            
            Text(isCompleted ? completedTitle : title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.black.opacity(textOpacity))
                .animation(.easeInOut(duration: 0.2), value: dragOffset)
                .animation(.easeInOut(duration: 0.25), value: isCompleted)
            
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .frame(height:65)
        .background(.white)
        .clipShape(Capsule())
    }
    
    private var textOpacity: CGFloat {
        if isCompleted { return 1 }
        let progress = min(dragOffset / 120, 1)
        return 1 - progress
    }
}
