//
//  RidePhotoView.swift
//  Fastgo
//
//  Created by vishwas on 2/7/26.
//

import SwiftUI

struct RidePhotoView: View {
    @EnvironmentObject private var router: HomeRouter
    @ObservedObject var rideViewModel: RideNavigationViewModel
    @StateObject private var viewModel: RidePhotoViewModel
    
    init(rideViewModel: RideNavigationViewModel) {
        self._rideViewModel = ObservedObject(wrappedValue: rideViewModel)
        self._viewModel = StateObject(wrappedValue: RidePhotoViewModel(
            userId: AppStateManager.shared.currentUser?.id,
            rideId: rideViewModel.currentRideId
        ))
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Take Photo")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Text("Capture a photo of the parked scooter to finish your ride")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.white.opacity(0.15))
                        .frame(maxWidth: .infinity , maxHeight: 400)
                    
                    if let image = viewModel.capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity , maxHeight: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                
                Spacer()
                
                VStack(spacing: 22) {
                    
                    CustomGreenButton(action: {
                        Task {
                            let success = await viewModel.submitPhoto()
                            if success {
                                rideViewModel.resetRideState()
                                router.navigateToHome()
                            }
                        }
                    }, title: "Submit photo", imageName: nil)
                    
                    Button("Retake") {
                        viewModel.retakePhoto()
                    }
                    .foregroundStyle(.white.opacity(0.9))
                    .font(.headline)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            if viewModel.isUploading {
                uploadingOverlay
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomToolBarBackButton(
                    foregroundColor: .white,
                    backgroundColor: .gray.opacity(0.1)
                )
            }
        }
        .onAppear {
            viewModel.openCamera()
        }
        .fullScreenCover(isPresented: $viewModel.isShowingCamera, onDismiss: {
            if viewModel.capturedImage == nil {
                router.navigatePop()
            }
        }) {
            CameraPicker(capturedImage: $viewModel.capturedImage)
                .ignoresSafeArea()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") { viewModel.showError = false }
        } message: {
            Text(viewModel.uploadError ?? "Something went wrong.")
        }
    }
    
    private var uploadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                
                Text("Uploading photo...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(32)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
