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
    
    @State private var cachedImage: UIImage?
    @State private var isLoading = false
    
    private var user: UserProfile? {
        AppStateManager.shared.currentUser
    }
    
    private var defaultAvatarName: String {
        (user?.gender == Gender.female.rawValue) ? AssetImage.Profile.avatarGirl : AssetImage.Profile.avatarBoy
    }
    
    init(size: CGFloat = 70, showEditButton: Bool = false) {
        self.size = size
        self.showEditButton = showEditButton
    }
    
    var body: some View {
        Group {
            if let cachedImage {
                Image(uiImage: cachedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else if let imageUrl = user?.profileImageUrl, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { phase in
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
                            .onAppear {
                                // Cache the downloaded image
                                if let uiImage = extractUIImage(from: image) {
                                    CacheManager.shared.save(image: uiImage, forKey: "cachedProfileImage")
                                }
                            }
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
        .onAppear {
            loadCachedImage()
        }
    }
    
    private var defaultAvatar: some View {
        Image(defaultAvatarName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
    
    private func loadCachedImage() {
        if let cached = CacheManager.shared.image(forKey: "cachedProfileImage") {
            cachedImage = cached
            print(cachedImage)
            print("📸 Loaded avatar from cache")
        }
    }
    
    private func extractUIImage(from image: Image) -> UIImage? {
        // This is a simple approach - for production you might want a more robust method
        let controller = UIHostingController(rootView: image)
        let view = controller.view
        
        let targetSize = CGSize(width: size, height: size)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}
