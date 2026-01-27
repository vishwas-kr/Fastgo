//
//  MyAccountViewModel.swift
//  Fastgo
//
//  Created by vishwas on 1/25/26.
//
import SwiftUI
import PhotosUI

@MainActor
class MyAccountViewModel : ObservableObject {
    @Published var draft: UserProfileDraft
    @Published var profileImageUrl : String?
    @Published var isLoading: Bool = false
    @Published var errorMessage : String?
    @Published var showError: Bool = false
    
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var profileImage : Image?
    
    private var originalDraft: UserProfileDraft
    
    private var isProfileDataChanged: Bool {
        draft.name != originalDraft.name ||
        draft.dateOfBirth != originalDraft.dateOfBirth ||
        draft.aboutMe != originalDraft.aboutMe ||
        draft.gender != originalDraft.gender
    }
    
    private var isImageChanged: Bool {
        selectedItem != nil
    }
    
    var hasUnsavedChanges: Bool {
        isProfileDataChanged || isImageChanged
    }
    
    var userId : String?
    
    init() {
        self.draft = .empty
        self.originalDraft = .empty
        resetStateFromUser(AppStateManager.shared.currentUser)
    }
    
    private static func makeDraft(from user: UserProfile?) -> UserProfileDraft {
        guard let user else {
            return UserProfileDraft.empty
        }
        
        return UserProfileDraft(
            name: user.name ?? "",
            dateOfBirth: user.dateOfBirth ?? "",
            aboutMe: user.aboutMe ?? "",
            gender: Gender(rawValue: user.gender ?? "") ?? .none
        )
    }
    
    func saveUserData() async {
        guard let userId else { return }
        isLoading = true
        errorMessage = nil
        showError = false
        
        do {
            // Upload image first if changed
            if selectedItem != nil {
                await uploadSelectedPhoto()
            }
            
            // Update profile data if changed
            if isProfileDataChanged {
                let updatedData = UpdateUserProfile(
                    name: draft.name,
                    aboutMe: draft.aboutMe,
                    gender: draft.gender.rawValue
                )
                
                try await UserService.shared.updateUserProfile(userId: userId, payload: updatedData)
            }
            
            // Refresh user data in AppStateManager - this will auto-cache
            await AppStateManager.shared.refreshUserProfile()
            
            resetStateFromUser(AppStateManager.shared.currentUser)
            
            print("Successfully Updated User Profile")
        } catch {
            print("Error Updating User Profile : \(error.localizedDescription)")
            errorMessage = "Failed to update profile: \(error.localizedDescription)"
            showError = true
        }
        isLoading = false
    }
    
    func loadSelectedPhotoPreview() async {
        guard let item = selectedItem else { return }
        
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else {
                return
            }
            
            // Update the preview image
            profileImage = Image(uiImage: uiImage)
        } catch {
            print("Failed to load photo preview:", error.localizedDescription)
        }
    }
    
    func uploadSelectedPhoto() async {
        guard let item = selectedItem else { return }
        guard let userId else { return }
        
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data),
                  let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
                errorMessage = "Could not load image data."
                showError = true
                return
            }
            
            // Keep the preview updated
            profileImage = Image(uiImage: uiImage)
            
            // Upload to storage
            let uploadedImageUrl = try await SupabaseService.shared.uploadProfileImage(userId: userId, imageData: imageData)
            
            // Update the URL in database
            await updateProfileImageUrl(uploadedImageUrl)
            
            // Cache the new image - this is critical!
            CacheManager.shared.save(image: uiImage, forKey: "cachedProfileImage")
            AppStateManager.shared.profileImage = uiImage
            
            print("Profile image uploaded and cached successfully")
        } catch {
            print("Failed to upload photo:", error.localizedDescription)
            errorMessage = "Failed to upload photo: \(error.localizedDescription)"
            showError = true
        }
    }
    
    private func updateProfileImageUrl(_ imageUrl: String) async {
        guard let userId else { return }
        
        do {
            try await UserService.shared.updateProfileImageUrl(userId: userId, imageUrl)
            
            // Update AppStateManager - this will auto-cache
            if var user = AppStateManager.shared.currentUser {
                user.profileImageUrl = imageUrl
                AppStateManager.shared.currentUser = user
            }
            
            // Update local reference
            profileImageUrl = imageUrl
        } catch {
            print("Failed to update the user profile image url: \(error.localizedDescription)")
        }
    }
    
    func checkCachedProfileImage() {
        // Load cached image for preview
        // This now gets the image directly from the AppStateManager
        if profileImage == nil, let uiImage = AppStateManager.shared.profileImage {
            profileImage = Image(uiImage: uiImage)
            print("Image loaded from cache")
        }
    }
    
    private func resetStateFromUser(_ user: UserProfile?) {
        self.userId = user?.id
        self.profileImageUrl = user?.profileImageUrl
        let newDraft = Self.makeDraft(from: user)
        self.draft = newDraft
        self.originalDraft = newDraft
        self.selectedItem = nil
    }
}

struct UserProfileDraft {
    var name: String
    var dateOfBirth: String
    var aboutMe: String
    var gender: Gender
}

extension UserProfileDraft {
    static let empty = UserProfileDraft(
        name: "",
        dateOfBirth: "",
        aboutMe: "",
        gender: .none
    )
}
