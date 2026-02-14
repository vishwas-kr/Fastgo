//
//  PaymentView.swift
//  Fastgo
//
//  Created by vishwas on 1/13/26.
//

import SwiftUI

struct PaymentView: View {
    @StateObject private var viewModel = PaymentViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PaymentTypeSelector(selected: $viewModel.selectedType)
                
                if viewModel.selectedType == .card {
                    CardPaymentSection(viewModel: viewModel)
                } else {
                    BankPaymentSection(viewModel: viewModel)
                }
                
                Spacer(minLength: 20)
                
                CustomGreenButton(action: {
                    Task { await viewModel.addPaymentMethod() }
                }, title: "Add", imageName: nil)
                .opacity(viewModel.canAddMore ? 1 : 0.5)
                .disabled(!viewModel.canAddMore)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Payment Method")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomToolBarBackButton()
            }
        }
        .task {
            await viewModel.fetchPaymentMethods()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") { viewModel.showError = false }
        } message: {
            Text(viewModel.errorMessage ?? "Something went wrong.")
        }
        .alert("Success", isPresented: $viewModel.showSuccess) {
            Button("OK") { viewModel.showSuccess = false }
        } message: {
            Text("Payment method added successfully!")
        }
    }
}

#Preview {
    NavigationStack {
        PaymentView()
    }
}
