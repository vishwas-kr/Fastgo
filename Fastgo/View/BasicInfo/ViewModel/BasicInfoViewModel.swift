//
//  BasicInfoViewModel.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//
import Foundation

@MainActor
class BasicInfoViewModel : ObservableObject {
    
    @Published var name: String = ""
    @Published var dateOfBirth = Date()
    @Published var gender : Gender = .none
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var navigateToSuccsees : Bool = false
    
    @Published var currentPage : BasicInfo = .name
    
    private func isNameValid() -> Bool{
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        if trimmedName.count < 3 || trimmedName.isEmpty {
            showErrorMessage("Name is too short. Name should be at least 3 characters long")
            showError = true
            return false
        }
        return true
    }
    
    func isDOBValid() -> Bool {
        print("Selected DOB: \(dateOfBirth)")
        let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
        print("Age: \(age)")
        if age < 12 {
            showErrorMessage("You should be 12+ to use this app")
            showError = true
            return false
        }
        return true
    }
    
    func isGenderValid() -> Bool {
        if gender == .none {
            showErrorMessage("Please choose your gender")
            showError = true
            return false
        }
        return true
    }
    
    private func isAllValidData () -> Bool {
        switch currentPage {
        case .name:
            return isNameValid()
        case .dob:
            return isDOBValid()
        case .gender:
            return isGenderValid()
        }
    }
    
    func backButton() {
        if let prev = BasicInfo(rawValue: currentPage.rawValue - 1) {
            currentPage = prev
        }
    }
    
    func nextButton() {
        guard isAllValidData() else { return }
        
        if let next = BasicInfo(rawValue: currentPage.rawValue + 1) {
            currentPage = next
        }
        
    }
    
    
    func submitBasicInfoDetails(userId: String) async {
        print("Name:\(name), DOB:\(dateOfBirth), Gender:\(gender)")
        
        guard !userId.isEmpty else {
            showErrorMessage("User ID not found. Please try logging in again.")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let updateData = try await UserService.shared.updateBasicInfo(
                userId: userId,
                name: name,
                dateOfBirth: dateOfBirth.toPostgresDateString(),
                gender: gender.rawValue
            )
            print("User profile updated successfully for: \(updateData.name ?? "Unknown")")
            AppStateManager.shared.currentUser = updateData
            isLoading = false
            navigateToSuccsees = true
            
        } catch {
            showErrorMessage("Failed to save profile. Please try again.")
            print("Error updating user profile: \(error.localizedDescription)")
            isLoading = false
            navigateToSuccsees = false
            
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.showError = false
        }
    }
}

extension Date {
    func toPostgresDateString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
