//
//  OnboardingViewModel.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//
import Foundation

enum OnboardingPage : Int, CaseIterable {
    case firstPage
    case secondPage
    case thirdPage
    
    var title : String{
        switch self {
        case .firstPage : return "Beat the traffic"
        case .secondPage : return "Quick rides big vibes."
        case .thirdPage : return "Just pure movement"
        }
    }
    
    var description : String {
        switch self {
        case .firstPage:
            return "One tap is all it takes to turn any street into a shortcut."
        case .secondPage:
            return "Your city never slows down, and neither should you."
        case .thirdPage:
            return "Less fuel, less noise, more freedom in every mile."
        }
    }
}

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
