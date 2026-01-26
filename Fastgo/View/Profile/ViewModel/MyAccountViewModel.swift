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
    
    @Published  var selectedItem: PhotosPickerItem? = nil
    @Published  var profileImage : Image?
    
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
    
    init(){
        let user = AppStateManager.shared.currentUser
        self.userId = user?.id
        self.profileImageUrl = user?.profileImageUrl
        let draft = Self.makeDraft(from: user)
        self.draft = draft
        self.originalDraft = draft
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
        guard let userId else {return}
        isLoading = true
        errorMessage = nil
        showError = false
        
        
        do {
            if selectedItem != nil { await uploadSelectedPhoto() }
            
            if isProfileDataChanged {
                let updatedData = UpdateUserProfile(
                    name: draft.name,
                    aboutMe: draft.aboutMe,
                    gender: draft.gender.rawValue,
                )
                
                try await UserService.shared.updateUserProfile(userId: userId, payload: updatedData)
            }
            
            await refreshLocalUser()
            print("Successfully Updated User Profile")
        } catch {
            print("Error Updating User Profile : \(error.localizedDescription)")
            errorMessage = "Failed to update profile: \(error.localizedDescription)"
            showError = true
        }
        isLoading = false
    }
    
    private func refreshLocalUser() async {
        do {
            let user = try await UserService.shared.getUser(userId: userId!)
            AppStateManager.shared.currentUser = user
        } catch {
            print("Failed to refresh user:", error)
        }
    }
    
    func loadSelectedPhotoPreview() async {
        guard let item = selectedItem else { return }
        
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else {
                return
            }
            
            profileImage = Image(uiImage: uiImage)
        } catch {
            print("Failed to load photo preview:", error.localizedDescription)
        }
    }
    
    
    func uploadSelectedPhoto() async {
        guard let item = selectedItem else { return }
        guard let userId else { return }
        isLoading = true
        errorMessage = nil
        showError = false
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data),
                  let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
                errorMessage = "Could not load image data."
                showError = true
                isLoading = false
                return
            }
            
            profileImage = Image(uiImage:uiImage)
            
            
            let uploadedImageUrl = try await SupabaseService.shared.uploadProfileImage(userId: userId, imageData: imageData)
            await updateProfileImageUrl(uploadedImageUrl)
            CacheManager.shared.save(image: uiImage,forKey: "cachedProfileImage")
            print("Profile image updated successfully")
        } catch {
            print("Failed to upload photo:", error.localizedDescription)
            errorMessage = "Failed to upload photo: \(error.localizedDescription)"
            showError = true
        }
        
        isLoading = false
    }
    
    private func updateProfileImageUrl(_ imageUrl: String)async{
        guard let userId else {return}
        do {
            try await UserService.shared.updateProfileImageUrl(userId: userId, imageUrl)
            AppStateManager.shared.currentUser?.profileImageUrl = imageUrl
        } catch {
            print("Failed to upadte the user profile image url: \(error.localizedDescription)")
        }
    }
    
    func checkCachedProfileImage(){
        guard let cachedImage = CacheManager.shared.image(forKey: "cachedProfileImage") else { return }
        profileImage = Image(uiImage: cachedImage)
        print("Image from Cache")
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
