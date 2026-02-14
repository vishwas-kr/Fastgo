//
//  PaymentViewModel.swift
//  Fastgo
//
//  Created by vishwas on 2/14/26.
//

import SwiftUI

@MainActor
class PaymentViewModel: ObservableObject {
    
    @Published var selectedType: PaymentType = .card
    
    @Published var cardNumber: String = ""
    @Published var cardHolderName: String = ""
    @Published var expiryDate: String = ""
    @Published var cvv: String = ""
    
    @Published var bankName: String = ""
    @Published var accountNumber: String = ""
    @Published var ifscCode: String = ""
    
    @Published var savedMethods: [PaymentMethod] = []
    @Published var currentCardIndex: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    
    private let userId: String?
    static let maxCards = 3
    
    init() {
        self.userId = AppStateManager.shared.currentUser?.id
    }
    
    var canAddMore: Bool {
        savedMethods.count < PaymentViewModel.maxCards
    }
    
    var savedCards: [PaymentMethod] {
        savedMethods.filter { $0.type == .card }
    }
    
    var savedBanks: [PaymentMethod] {
        savedMethods.filter { $0.type == .bank }
    }
    
    var formattedCardNumber: String {
        let cleaned = cardNumber.replacingOccurrences(of: " ", with: "")
        let groups = stride(from: 0, to: cleaned.count, by: 4).map { i -> String in
            let start = cleaned.index(cleaned.startIndex, offsetBy: i)
            let end = cleaned.index(start, offsetBy: min(4, cleaned.count - i))
            return String(cleaned[start..<end])
        }
        return groups.joined(separator: " ")
    }
    
    var displayCardNumber: String {
        let formatted = formattedCardNumber
        return formatted.isEmpty ? "**** **** **** ****" : formatted
    }
    
    var displayExpiry: String {
        expiryDate.isEmpty ? "MM/YY" : expiryDate
    }
    
    var displayCVV: String {
        cvv.isEmpty ? "CVV" : String(repeating: "*", count: cvv.count)
    }
    
    private var isCardValid: Bool {
        let cleanedCard = cardNumber.replacingOccurrences(of: " ", with: "")
        return cleanedCard.count == 16
            && !cardHolderName.trimmingCharacters(in: .whitespaces).isEmpty
            && expiryDate.count == 5
            && cvv.count >= 3 && cvv.count <= 4
    }
    
    private var isBankValid: Bool {
        let cleanedAccount = accountNumber.trimmingCharacters(in: .whitespaces)
        return !bankName.trimmingCharacters(in: .whitespaces).isEmpty
            && cleanedAccount.count >= 9 && cleanedAccount.count <= 17
            && ifscCode.trimmingCharacters(in: .whitespaces).count == 11
    }
    
    func formatCardNumber(_ value: String) {
        let cleaned = value.replacingOccurrences(of: " ", with: "").prefix(16)
        let digits = String(cleaned.filter { $0.isNumber })
        cardNumber = digits
    }
    
    func formatExpiry(_ value: String) {
        let cleaned = value.replacingOccurrences(of: "/", with: "").prefix(4)
        let digits = String(cleaned.filter { $0.isNumber })
        if digits.count > 2 {
            let month = digits.prefix(2)
            let year = digits.suffix(from: digits.index(digits.startIndex, offsetBy: 2))
            expiryDate = "\(month)/\(year)"
        } else {
            expiryDate = digits
        }
    }
    
    func formatCVV(_ value: String) {
        cvv = String(value.filter { $0.isNumber }.prefix(4))
    }
    
    func formatAccountNumber(_ value: String) {
        accountNumber = String(value.filter { $0.isNumber }.prefix(17))
    }
    
    func formatIFSC(_ value: String) {
        ifscCode = String(value.uppercased().prefix(11))
    }
    
    func fetchPaymentMethods() async {
        guard let userId = userId else { return }
        isLoading = true
        do {
            savedMethods = try await PaymentService.shared.fetchPaymentMethods(userId: userId)
            if !savedMethods.isEmpty {
                currentCardIndex = 0
            }
        } catch {
            print("Error fetching payment methods: \(error)")
            errorMessage = "Failed to load payment methods."
            showError = true
        }
        isLoading = false
    }
    
    func addPaymentMethod() async {
        guard let userId = userId else {
            errorMessage = "User not found."
            showError = true
            return
        }
        
        guard canAddMore else {
            errorMessage = "Maximum of \(PaymentViewModel.maxCards) payment methods allowed."
            showError = true
            return
        }
        
        if selectedType == .card && !isCardValid {
            errorMessage = "Please fill in all card details correctly."
            showError = true
            return
        }
        
        if selectedType == .bank && !isBankValid {
            errorMessage = "Please fill in all bank details correctly."
            showError = true
            return
        }
        
        isLoading = true
        
        let payload = PaymentMethod(
            id: UUID().uuidString,
            userId: userId,
            type: selectedType,
            cardNumber: selectedType == .card ? cardNumber.replacingOccurrences(of: " ", with: "") : nil,
            cardHolderName: selectedType == .card ? cardHolderName.trimmingCharacters(in: .whitespaces) : nil,
            expiryDate: selectedType == .card ? expiryDate : nil,
            cvv: selectedType == .card ? cvv : nil,
            bankName: selectedType == .bank ? bankName.trimmingCharacters(in: .whitespaces) : nil,
            accountNumber: selectedType == .bank ? accountNumber : nil,
            ifscCode: selectedType == .bank ? ifscCode.trimmingCharacters(in: .whitespaces) : nil,
            createdAt: Date()
        )
        
        do {
            let saved = try await PaymentService.shared.addPaymentMethod(payload: payload)
            savedMethods.insert(saved, at: 0)
            currentCardIndex = 0
            clearForm()
            showSuccess = true
            print("Payment method added successfully: \(saved.id)")
        } catch {
            print("Error adding payment method: \(error)")
            errorMessage = "Failed to add payment method: \(error.localizedDescription)"
            showError = true
        }
        
        isLoading = false
    }
    
    func deletePaymentMethod(at index: Int) async {
        guard index < savedMethods.count else { return }
        let method = savedMethods[index]
        
        isLoading = true
        do {
            try await PaymentService.shared.deletePaymentMethod(id: method.id)
            savedMethods.remove(at: index)
            if currentCardIndex >= savedMethods.count {
                currentCardIndex = max(0, savedMethods.count - 1)
            }
        } catch {
            print("Error deleting payment method: \(error)")
            errorMessage = "Failed to delete payment method."
            showError = true
        }
        isLoading = false
    }
    
    private func clearForm() {
        cardNumber = ""
        cardHolderName = ""
        expiryDate = ""
        cvv = ""
        bankName = ""
        accountNumber = ""
        ifscCode = ""
    }
}
