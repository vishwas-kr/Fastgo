//
//  FastgoApp.swift
//  Fastgo
//
//  Created by vishwas on 12/25/25.
//

import SwiftUI

@main
struct FastgoApp: App {
    @StateObject private var router = Router()
    @StateObject private var appState = AppStateManager.shared
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath){
                RootView()
                    .navigationDestination(for: Router.AuthFlow.self){ destination in
                        switch destination {
                        case .onboarding: OnboardingView(appState: appState, router: router)
                        case .signIn: SignInView()
                        case .verifyOTP: OPTVerifyView()
                        case .newOnboardingSuccess : NewOnboardingSuccessView()
                        case .basicInfo : BasicInfoView()
                        case .home: HomeView()
                        }
                    }
            }
            .environmentObject(router)
            .environmentObject(appState)
            .onAppear{
                appState.checkAppStatus()
            }
        }
    }
}


struct RootView: View {
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject var router: Router
    var body: some View {
        if !appState.hasSeenOnboarding {
            OnboardingView(appState: appState, router: router)
        } else if !appState.isLoggedIn {
            SignInView()
        } else if !appState.isProfileComplete {
            BasicInfoView()
        } else {
            HomeView()
        }
    }
}
