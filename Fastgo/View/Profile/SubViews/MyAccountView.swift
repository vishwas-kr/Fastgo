//
//  MyAccountView.swift
//  Fastgo
//
//  Created by vishwas on 1/13/26.
//

import SwiftUI
import PhotosUI

struct MyAccountView: View {
    @FocusState var isFocused : Bool
    @StateObject private var viewModel = MyAccountViewModel()
    @State private var isShowingPhotoPicker = false
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                MyAccountHeader(viewModel: viewModel,isShowingPhotoPicker: $isShowingPhotoPicker)
                VStack(spacing: 12) {
                    MyAccountTextField(title: "Name", text: $viewModel.draft.name)
                    MyAccountTextField(title: "Date of birth", text: $viewModel.draft.dateOfBirth)
                        .disabled(true)
                    MyAccountTextField(title: "About yourself", text: $viewModel.draft.aboutMe)
                }
                Text("Gender")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                HStack{
                    MyAccountGenderBox(image: "\u{2642}",gender: .male,selectedGender: $viewModel.draft.gender)
                    Spacer()
                    MyAccountGenderBox(image: "\u{2640}",gender: .female,selectedGender: $viewModel.draft.gender)
                }
                
                Spacer()
                CustomGreenButton(action: {
                    Task{
                        await viewModel.saveUserData()
                    }
                }, title: "Save")
                .disabled(!viewModel.hasUnsavedChanges)
                .opacity(viewModel.hasUnsavedChanges ? 1 : 0.5)
            }
            .padding()
            .background(Color(.systemGray6))
            .navigationBarBackButtonHidden(true)
            
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .navigationTitle("My Account")
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                CustomToolBarBackButton()
            }
        }
        .photosPicker(isPresented: $isShowingPhotoPicker, selection: $viewModel.selectedItem)
        .onChange(of: viewModel.selectedItem) {
            Task {
                await viewModel.loadSelectedPhotoPreview()
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

#Preview {
    MyAccountView()
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                ProgressView()
                    .scaleEffect(1.2)
                
                Text("Saving...")
                    .font(.footnote)
                    .foregroundStyle(.white)
            }
            .padding(24)
            .background(Color.black.opacity(0.7))
            .cornerRadius(12)
        }
    }
}

