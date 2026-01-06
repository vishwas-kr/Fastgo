//
//  OnboardingViewModel.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//
import Foundation

class OnboardingViewModel : ObservableObject {
    
    @Published var currentPage: Int = 0
    
    private let appState: AppStateManager
    
    init(appState: AppStateManager) {
        self.appState = appState
    }
    
    
    var totalPages: Int {
        OnboardingPage.allCases.count
    }
    
    var isLastPage: Bool {
        currentPage == totalPages - 1
    }
    
    var buttonTitle: String {
        isLastPage ? "Get Started" : "Next"
    }
    
    @MainActor func nextButton(){
        if isLastPage {
            completeOnboarding()
        } else {
            currentPage += 1
        }
    }
    
    @MainActor private func completeOnboarding() {
        appState.completeOnboarding()
    }
}
