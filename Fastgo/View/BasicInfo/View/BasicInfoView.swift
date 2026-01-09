//
//  BasicInfoView.swift
//  Fastgo
//
//  Created by vishwas on 12/29/25.
//

import SwiftUI

struct BasicInfoView: View {
    @StateObject private var viewModel = BasicInfoViewModel()
    @EnvironmentObject var appState: AppStateManager
    var body: some View {
        NavigationStack {
            VStack{
                progressBar
                
                BasicInfoHeaderView(title: viewModel.currentPage.title, description: viewModel.currentPage.description)
                    .padding()
                
                Group {
                    switch viewModel.currentPage {
                    case .name:
                        NameView(name: $viewModel.name)
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                    case .dob:
                        DateOfBirthView(dateOfBirth: $viewModel.dateOfBirth)
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                    case .gender:
                        GenderCardView(selectedGender: $viewModel.gender)
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                    }
                }
                .animation(.easeInOut(duration: 0.35), value: viewModel.currentPage)
                
                Spacer()
                
                HStack{
                    
                    if (viewModel.currentPage.rawValue != 0){
                        Button(action:viewModel.backButton){
                            Text("Back")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.green)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height:55)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(.green)
                                )
                        }
                    }
                    
                    Button(action:  {
                        if viewModel.currentPage.rawValue < BasicInfo.allCases.count-1 {
                            viewModel.nextButton()
                        } else {
                            Task{
                                await viewModel.submitBasicInfoDetails(userId: appState.userID ?? "")
                            }
                        }
                    }){
                        Text(viewModel.currentPage.rawValue >= 2 ? "Submit" : "Next")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height:55)
                            .background(.green)
                            .clipShape(Capsule())
                        
                    }
                }
                
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
            .navigationDestination(isPresented: $viewModel.navigateToSuccsees){NewOnboardingSuccessView()}
        }
    }
    
    private var progressBar: some View {
        HStack{
            ForEach(0..<BasicInfo.allCases.count, id:\.self){index in
                Rectangle()
                    .foregroundColor(index <= viewModel.currentPage.rawValue ? .green : .gray.opacity(0.2))
                    .frame(maxWidth: 55, maxHeight: 8)
                    .cornerRadius(12)
                    .animation(.spring(), value:viewModel.currentPage)
            }
        }.padding(.bottom,16)
    }
    
    
}

#Preview {
    BasicInfoView()
}




