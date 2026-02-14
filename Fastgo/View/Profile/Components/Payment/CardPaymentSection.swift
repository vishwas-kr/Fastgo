//
//  CardPaymentSection.swift
//  Fastgo
//
//  Created by vishwas on 2/14/26.
//

import SwiftUI

struct CardPaymentSection: View {
    @ObservedObject var viewModel: PaymentViewModel
    @FocusState private var focusedField: CardField?
    
    private enum CardField {
        case number
        case holder
        case expiry
        case cvv
    }
    
    var body: some View {
        VStack(spacing: 16) {
            cardCarousel
            cardProgressBar
            
            Text("Card Details")
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            
            MyAccountTextField(title: "Card Number", text: Binding(
                get: { viewModel.formattedCardNumber },
                set: { viewModel.formatCardNumber($0) }
            ))
            .keyboardType(.numberPad)
            .focused($focusedField, equals: .number)
            .onChange(of: viewModel.cardNumber) {
                if viewModel.cardNumber.count == 16 {
                    focusedField = .holder
                }
            }
            
            MyAccountTextField(title: "Card Holder Name", text: $viewModel.cardHolderName)
                .focused($focusedField, equals: .holder)
            
            HStack(spacing: 12) {
                MyAccountTextField(title: "MM/YY", text: Binding(
                    get: { viewModel.expiryDate },
                    set: { viewModel.formatExpiry($0) }
                ))
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .expiry)
                .onChange(of: viewModel.expiryDate) {
                    if viewModel.expiryDate.count == 5 {
                        focusedField = .cvv
                    }
                }
                
                MyAccountTextField(title: "CVV", text: Binding(
                    get: { viewModel.cvv },
                    set: { viewModel.formatCVV($0) }
                ))
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .cvv)
                .onChange(of: viewModel.cvv) {
                    // Dismiss keyboard after 4 digits for CVV
                    if viewModel.cvv.count == 4 {
                        focusedField = nil
                    }
                }
            }
        }
    }
    
    private var cardCarousel: some View {
        TabView(selection: $viewModel.currentCardIndex) {
            PaymentCardUI(
                number: viewModel.displayCardNumber,
                expiry: viewModel.displayExpiry,
                cvv: viewModel.displayCVV,
                color: .purple
            )
            .tag(-1)
            
            ForEach(Array(viewModel.savedCards.enumerated()), id: \.element.id) { index, card in
                PaymentCardUI(
                    number: formatSavedCardNumber(card.cardNumber ?? ""),
                    expiry: card.expiryDate ?? "--/--",
                    cvv: "***",
                    color: cardColor(for: index)
                )
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 220)
        .onAppear {
            viewModel.currentCardIndex = -1
        }
    }
    
    private var cardProgressBar: some View {
        HStack {
            let totalDots = viewModel.savedCards.count + 1
            ForEach(0..<totalDots, id: \.self) { index in
                let dotIndex = index - 1
                Rectangle()
                    .foregroundColor(dotIndex == viewModel.currentCardIndex ? .green : .gray.opacity(0.2))
                    .frame(maxWidth: dotIndex == viewModel.currentCardIndex ? 35 : 8, maxHeight: 8)
                    .cornerRadius(12)
                    .animation(.spring(), value: viewModel.currentCardIndex)
            }
        }
        .padding(.vertical, 12)
    }
    
    private func formatSavedCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        guard cleaned.count >= 4 else { return "**** **** **** ****" }
        let last4 = String(cleaned.suffix(4))
        return "**** **** **** \(last4)"
    }
    
    private func cardColor(for index: Int) -> Color {
        let colors: [Color] = [.blue, .orange, .teal]
        return colors[index % colors.count]
    }
}
