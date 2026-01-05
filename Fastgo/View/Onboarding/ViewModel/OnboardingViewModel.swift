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
    private let router: Router
    
    init(appState: AppStateManager, router: Router) {
        self.appState = appState
        self.router = router
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
    
    func nextButton(){
        if isLastPage {
            completeOnboarding()
        } else {
            currentPage += 1
        }
    }
    
    private func completeOnboarding() {
        router.navigate(to: .signIn)
        appState.setOnboadringSeen()
    }
}
