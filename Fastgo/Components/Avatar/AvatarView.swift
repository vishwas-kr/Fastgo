//
//  AvatarView.swift
//  Fastgo
//
//  Created by vishwas on 1/26/26.
//
import SwiftUI

struct AvatarView: View {
    let size: CGFloat
    let showEditButton: Bool
    @StateObject private var appState = AppStateManager.shared
    
    private var defaultAvatarName: String {
        (user?.gender == Gender.female.rawValue) ? AssetImage.Profile.avatarGirl : AssetImage.Profile.avatarBoy
    }
    
    init(size: CGFloat = 70, showEditButton: Bool = false) {
        self.size = size
        self.showEditButton = showEditButton
    }
    
    private var user: UserProfile? {
        appState.currentUser
    }
    
    var body: some View {
        Group {
            if let profileImage = appState.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else if let imageUrl = user?.profileImageUrl, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl), transaction: Transaction(animation: .easeIn)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: size, height: size)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                    case .failure:
                        defaultAvatar
                    @unknown default:
                        defaultAvatar
                    }
                }
            } else {
                defaultAvatar
            }
        }
        .overlay(alignment: .bottomTrailing) {
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
    
    private var defaultAvatar: some View {
        Image(defaultAvatarName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}
