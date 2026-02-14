//
//  BankPaymentSection.swift
//  Fastgo
//
//  Created by vishwas on 2/14/26.
//

import SwiftUI

struct BankPaymentSection: View {
    @ObservedObject var viewModel: PaymentViewModel
    @FocusState private var focusedField: BankField?
    
    private enum BankField {
        case name, account, ifsc
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if !viewModel.savedBanks.isEmpty {
                savedBanksList
            }
            
            Text("Bank Details")
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            
            MyAccountTextField(title: "Bank Name", text: $viewModel.bankName)
                .focused($focusedField, equals: .name)
            
            MyAccountTextField(title: "Account Number", text: Binding(
                get: { viewModel.accountNumber },
                set: { viewModel.formatAccountNumber($0) }
            ))
            .keyboardType(.numberPad)
            .focused($focusedField, equals: .account)
            .onChange(of: viewModel.accountNumber) {
                if viewModel.accountNumber.count == 17 {
                    focusedField = .ifsc
                }
            }
            
            MyAccountTextField(title: "IFSC Code", text: Binding(
                get: { viewModel.ifscCode },
                set: { viewModel.formatIFSC($0) }
            ))
            .focused($focusedField, equals: .ifsc)
            .onChange(of: viewModel.ifscCode) {
                // Dismiss keyboard after 11 chars for IFSC
                if viewModel.ifscCode.count == 11 {
                    focusedField = nil
                }
            }
        }
    }
    
    private var savedBanksList: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.savedBanks) { bank in
                HStack(spacing: 12) {
                    Image(systemName: "building.columns")
                        .font(.title3)
                        .foregroundStyle(.green)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.green.opacity(0.1)))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(bank.bankName ?? "Bank")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("A/C: ****\(String((bank.accountNumber ?? "").suffix(4)))")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Text(bank.ifscCode ?? "")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                )
            }
        }
    }
}
