//
//  AvatarView.swift
//  Fastgo
//
//  Created by vishwas on 1/26/26.
//
import SwiftUI

struct AvatarView: View {
    let cachedImage: Image?
    let imageUrl : String?
    let gender : Gender
    let showEditButton : Bool
    let size : CGFloat
    
    init(cachedImage: Image?, imageUrl: String?, gender: Gender, showEditButton: Bool = false, size: CGFloat = 70) {
        self.cachedImage = cachedImage
        self.imageUrl = imageUrl
        self.gender = gender
        self.showEditButton = showEditButton
        self.size = size
    }
    
    private var defaultAvatarName: String {
        gender == .female ? "girl" : "boy"
    }
    
    var body : some View {
        Group{
            if let cachedImage {
                cachedImage
                    .resizable()
                    .scaledToFill()
                    .frame(width:size,height:size)
                    .clipShape(Circle())
            } else if let imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width:size,height:size)
                .clipShape(Circle())
            } else {
                Image(defaultAvatarName)
                    .resizable()
                    .frame(width:size,height:size)
                    .overlay(alignment:.bottomTrailing){
                        if showEditButton {
                            Image(systemName: "pencil")
                                .font(.headline)
                                .padding(4)
                                .foregroundStyle(.white)
                                .background(.green)
                                .clipShape(Circle())
                        }
                    }
            }
        }
        .padding(.trailing, 8)
    }
}

