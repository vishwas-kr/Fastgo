//
//  RidePhotoViewModel.swift
//  Fastgo
//
//  Created by vishwas on 2/7/26.
//

import SwiftUI
import UIKit

@MainActor
class RidePhotoViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var isShowingCamera: Bool = false
    @Published var isUploading: Bool = false
    @Published var uploadError: String?
    @Published var showError: Bool = false
    
    private let userId: String?
    private let rideId: String?
    
    init(userId: String?, rideId: String?) {
        self.userId = userId
        self.rideId = rideId
    }
    
    var hasPhoto: Bool {
        capturedImage != nil
    }
    
    func openCamera() {
        isShowingCamera = true
    }
    
    func retakePhoto() {
        capturedImage = nil
        isShowingCamera = true
    }
    
    func submitPhoto() async -> Bool {
        guard let image = capturedImage,
              let userId = userId,
              let rideId = rideId else {
            uploadError = "Missing ride or user information."
            showError = true
            return false
        }
        
        guard let imageData = image.pngData() else {
            uploadError = "Could not process the image."
            showError = true
            return false
        }
        
        isUploading = true
        
        do {
            let photoUrl = try await SupabaseService.shared.uploadRideCompletedPhoto(
                userId: userId,
                rideId: rideId,
                imageData: imageData
            )
            
            let payload = RidePhotoUpdatePayload(rideCompletedPhotoUrl: photoUrl)
            try await RideService.shared.updateRidePhoto(rideId: rideId, payload: payload)
            
            print("Ride photo uploaded successfully: \(photoUrl)")
            isUploading = false
            return true
        } catch {
            print("Error uploading ride photo: \(error)")
            uploadError = "Failed to upload photo: \(error.localizedDescription)"
            showError = true
            isUploading = false
            return false
        }
    }
}
